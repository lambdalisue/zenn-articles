---
title: "GPG 鍵と YubiKey の運用メモ"
emoji: "🗝️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["gpg", "yubikey"]
published: false
---

どうも、ありすえです。

GPG 鍵と YubiKey の運用に関して無限に悩んだので、将来の自分のために書き残しておこうと思います。なお、YubiKey 使ってる理由はロマンが9割なので、正直そこまでセキュアな運用は目指していません。また、記事の内容には一切の責任を持ちませんので、真似する場合は自己責任でお願いします。

# 基本方針

いままでは YubiKey に署名用の副鍵を入れて、その副鍵を使ってコミット署名をしていました。
ただ、この方法には問題があり、なんと**MacBook Pro には USB-A タイプの YubiKey が刺さらないんです！おぉ、アップルよ互換性を削ってしまうとは何事か。**

:::message
[USB-C タイプの YubiKey 5](https://www.yubico.com/jp/product/yubikey-5-series/yubikey-5c-nfc/) があるので、それを使えばいいじゃん！と思う方も多いでしょう。
僕は上記の存在を把握し、MacBook Pro を所持していた上で「USB-A タイプの方が汎用性が高くて良いよね🙃」と（なぜか）考え USB-A タイプの YubiKey 5 を二個も買ってしまったので、今更 USB-C タイプを買い直す気になりません。
ちなみに購入から数年経過した今も、引き出しの中には新品未開封の USB-A YubiKey 5 が一つ眠っています🫠
::: 

自宅は Thunderbolt ドックを中心とした環境が整っているので問題ありませんが、出先でコミット署名をするには USB-C ハブを持ち歩く必要があります。

**もちろん、そんなもの持ち歩くわけないので、出先では `.gitconfig` を書き換えてコミット署名をオフってコミットしてました。本末転倒ですね🙃**

[![Unusable security is not security](https://image.slidesharecdn.com/pmojekgrboprpmwzncxa-signature-e53707368948893b9fc4f3145b4a12d4be392a4070fc060c7e211959c3d8bbd5-poli-151124194709-lva1-app6891/75/DockerCon-EU-2015-Day-1-General-Session-63-2048.jpg)](https://www.slideshare.net/slideshow/dockercon-eu-day-1-general-session/55478588#63)

[YubikeyでOpenPGP鍵をセキュアに使う] でも言われているように、署名用の秘密鍵と暗号化用の秘密鍵では流出時のリスクが異なります。そのため、使用感とのバランスを取ると、署名用はデバイスに保存し、暗号化用は YubiKey に焼いてしまうのが良さそうです。

以上より、今回は以下の方針で運用することにしました。基本的には [YubiKey(OpenPGP card)には主鍵を入れよう] で提案されている方針そのままです。

- YubiKey には主鍵と副鍵 (Encrypt) を焼き、持ち歩く
- YubiKey の主鍵を利用して副鍵 (Sign) をデバイス毎に作成・保存しておく
- コミット署名はデバイス毎の副鍵 (Sign) を利用する
- 暗号化・復号機能は YubiKey の副鍵 (Encrypt) を利用する

[YubikeyでOpenPGP鍵をセキュアに使う]: https://keens.github.io/blog/2021/03/23/yubikeywotsukau_openpghen/
[YubiKey(OpenPGP card)には主鍵を入れよう]: https://fuwa.dev/posts/yubikey/

# GPG 鍵の生成

以下は [【令和最新版】PGP鍵の作り方から管理方法、Git Commitへの署名まで] を目的に合わせて少し改変した感じです。詳細を知りたいからはオリジナルを参照すると良いと思います。

[【令和最新版】PGP鍵の作り方から管理方法、Git Commitへの署名まで]: https://qiita.com/shun-shobon/items/a944416bebb6207016fb

## 主鍵の編集

すでに利用している主鍵があるので、今回の目的に合うように修正していきます。まず、現在の主鍵は Sign が有効になっていたので、これをオフにします。鍵を指定して `gpg --edit-key` を実行します。

:::message
なお、例の中で `<鍵ID>` としている部分は鍵の指紋や鍵に設定されている UID など、鍵を一意に決定できるものを指定してください。
:::

```console
$ gpg --edit-key <鍵ID>
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: SC
     trust: unknown       validity: unknown
...略...
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>
```

`gpg>` というプロンプトが表示されたら `change-usage` コマンドを実行します。すると機能のトグル対話インターフェースに変わるので、署名機能をオフ (`s`) して完了 (`q`) し `save` コマンドで変更を保存します。**`save` 忘れがちなので注意です。**

```console
gpg> change-usage
Changing usage of the primary key.

Possible actions for this RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Sign Certify

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for this RSA key: Sign Certify Encrypt Authenticate
Current allowed actions: Certify

   (S) Toggle the sign capability
   (E) Toggle the encrypt capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     trust: unknown       validity: unknown
...略...
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

gpg> save
```

## 副鍵 (Encrypt) の追加

次に主鍵に副鍵 (Encrypt) を追加します。詳細指定したいので `--expert` を指定して実行します。

```console
$ gpg --expert --edit-key <鍵ID>
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     trust: unknown       validity: unknown
...略...
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>
```

`gpg> ` という対話型プロンプトが表示されるので、`addkey` コマンドを実行します。すると、何がしたいのか問われるので、`(12) ECC (encrypt only)` を選択します。その後はデフォルトで進めていけば、Curve 25519, 有効期限無しな副鍵 (Encrypt) が生成されます。

:::message
暗号化用の副鍵なので有効期限を設定したほうが良さそうにも思いますが、YubiKey に焼く時点で流出リスクは低いと判断し「有効期限なし」を選択しています（有効期限切れるたびに YubiKey に焼き直すのが面倒ともいう）。
:::

```console
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (12) ECC (encrypt only)
  (13) Existing key
  (14) Existing key from card
Your selection? 12
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (2) Curve 448
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection?
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     trust: unknown       validity: unknown
...略...
ssb  cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

gpg> save
```

なお、上記では最後に `save` コマンドを実行して、鍵を書き込んでいます。**これを実施しないと副鍵は書き込まれないので注意してください。**

## 秘密鍵と失効証明書の退避

秘密鍵は YubiKey に焼いてしまうため、バックアップをとっておきます。加えて、万が一のために失効証明書も生成しておきます。

```console
$ gpg --armor --export-secret-keys <鍵ID> > ~/key.gpg
$ gpg --gen-revoke <鍵ID> > ~/key.rev
```

生成した `key.gpg` および `key.rev` は安全な場所に退避しておきます。僕はパスワードマネージャーを利用しているので、そこに保存してます。退避が終わったら、エクスポートしたファイルは削除します。

```console
$ rm -f ~/key.gpg ~/key.rev
```

:::message
ローカルで利用するパスワードマネージャーに秘密鍵だったり失効証明書だったりを保存しちゃうと、せっかく YubiKey に焼いてる意味がほとんどないわけですが、まぁただのロマンなのでいいでしょう。気になる方は印刷して耐火金庫に保存するなりすると良さそうです。
:::

## 公開鍵の登録

`--armor` をつけることで PEM 方式でエクスポートできます。

```console
$ gpg --armor --export <鍵ID> > ~/key.pub
```

上記でエクスポートした公開鍵を配るのは面倒なので、どこかに登録します。とりあえず僕は以下のサービスに登録しています。

### [keys.openpgp.org](https://keys.openpgp.org)

[Uploading your key](https://keys.openpgp.org/about/usage#gnupg-upload) に従って、以下のコマンドで公開鍵をアップロードします。

```console
$ gpg --export <鍵ID> | curl -T - https://keys.openpgp.org
```

### [Keybase](https://keybase.io/)

`keybase` CLI コマンドが有効ならば、以下のコマンドで公開鍵をアップロードできます。Web UI から更新も可能です。

```console
$ keybase pgp update <鍵ID>
```

### [GitHub](https://github.com)

`gh` CLI コマンドが有効ならば、以下のコマンドで公開鍵をアップロードできます。ただし、登録済みの場合は先に削除が必要だったりと面倒なので Web UI から作業する方が楽かもしれません。

```console
$ gh gpg-key add ~/key.pub
```

# YubiKey への焼き付け

ほぼ [PGP鍵をYubiKeyで管理する手引き] のままですが、鍵の転送時に主鍵も転送してしまう点が異なります。

[PGP鍵をYubiKeyで管理する手引き]: https://qiita.com/shun-shobon/items/96f08aa09a30c26a55b5

## 初期化と設定

まず、まっさらな状態から始めるために YubiKey のファクトリーリセットを行います。これにより PIN/Admin PIN がデフォルト値 (`123456/12345678`) に戻ります。`ykman` コマンドが必要なので、あらかじめインストールしておいてください。

```console
$ ykman openpgp reset
WARNING! This will delete all stored OpenPGP keys and data and restore factory settings. Proceed? [y/N]: y
Resetting OpenPGP data, don't remove the YubiKey...
Success! All data has been cleared and default PINs are set.
PIN:         123456
Reset code:  NOT SET
Admin PIN:   12345678
```

次に YubiKey の設定を行っていきます。admin モードに入り Key Derived Function (KDF) を有効にしてから PIN および Admin PIN を変更します。この順番を間違えると PIN が通らなくなるらしいので注意です。

なお、ここで Reset Code も設定できますが、忘れるとファクトリーリセットすら出来なくなるようなので僕は設定していません。

```console
$ gpg --edit-card

Reader ...........: Yubico YubiKey OTP FIDO CCID
Application ID ...: ********************************
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....: ********
Name of cardholder: [not set]
Language prefs ...: [not set]
Salutation .......:
URL of public key : [not set]
Login data .......: [not set]
Signature PIN ....: not forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 0 3
Signature counter : 0
KDF setting ......: off
UIF setting ......: Sign=off Decrypt=off Auth=off
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
General key info..: [none]

gpg/card> admin
Admin commands are allowed

gpg/card> kdf-setup

gpg/card> passwd
gpg: OpenPGP card no. ******************************** detected

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 1
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? 3
PIN changed.

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

Your selection? q
```

次にカードの所有者と公開鍵の URL を設定します。公開鍵の URL に関しては先にアップロードしておいた keys.openpgp.org の URL を指定しました。

```console
gpg/card> name
Cardholder's surname: Alisue
Cardholder's given name:

gpg/card> salutation
Salutation (M = Mr., F = Ms., or space): M

gpg/card> lang
Language preferences: ja

gpg/card> login
Login data (account name): lambdalisue@gmail.com

gpg/card> url
URL to retrieve public key: https://keys.openpgp.org/vks/v1/by-fingerprint/DF391438E6C2FA2A6398BDEEB11731DAB90A2400

gpg/card> list

Reader ...........: Yubico YubiKey OTP FIDO CCID
Application ID ...: ********************************
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....: ********
Name of cardholder: Alisue
Language prefs ...: ja
Salutation .......: Mr.
URL of public key : https://keys.openpgp.org/vks/v1/by-fingerprint/DF391438E6C2FA2A6398BDEEB11731DAB90A2400
Login data .......: lambdalisue@gmail.com
Signature PIN ....: not forced
Key attributes ...: rsa2048 rsa2048 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 0 3
Signature counter : 0
KDF setting ......: on
UIF setting ......: Sign=off Decrypt=off Auth=off
Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]
General key info..: [none]

gpg/card> quit
```

## 鍵の転送

最後に YubiKey に主鍵と副鍵を転送します。主鍵を転送するには *鍵を選択する前* に `keytocard` コマンドを実行します。副鍵は *鍵を選択した後* に `keytocard` コマンドを実行します。**最後に `save` コマンドを実行すると、ローカルから秘密鍵が削除されます**。

```console
$ gpg --edit-key <鍵ID>
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: unknown       validity: unknown
...略...
ssb  cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

gpg> keytocard
Really move the primary key? (y/N) y
Please select where to store the key:
   (1) Signature key
Your selection? 1

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: unknown       validity: unknown
...略...
ssb  cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

Note: the local copy of the secret key will only be deleted with "save".
gpg> key 8

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: unknown       validity: unknown
...略...
ssb* cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

gpg> keytocard
Please select where to store the key:
   (2) Encryption key
Your selection? 2

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: unknown       validity: unknown
...略...
ssb* cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
[ unknown] (1). Alisue <lambdalisue@gmail.com>
[ unknown] (2). [jpeg image of size 5114]
[ unknown] (3)  Alisue <lambdalisue@hashnote.net>

Note: the local copy of the secret key will only be deleted with "save".
gpg> save
```

`gpg -K` で秘密鍵一覧を見ると、主鍵も副鍵もポインターのみが残っていることが `>` で `sec>` や `ssb>` のように示されています。

```console
$ gpg -K
/Users/alisue/.gnupg/pubring.kbx
--------------------------------
sec>  rsa4096 2018-04-17 [C]
      DF391438E6C2FA2A6398BDEEB11731DAB90A2400
      Card serial no. = 0006 16615774
uid           [ unknown] Alisue <lambdalisue@gmail.com>
uid           [ unknown] [jpeg image of size 5114]
uid           [ unknown] Alisue <lambdalisue@hashnote.net>
ssb>  cv25519 2024-06-23 [E]
```

## クリーンアップ

最後に、以下のディレクトリをチェックして不要なファイルが残っていないことを確認します。

- `~/.gnupg/private-keys-v1.d` - 鍵生成時の秘密鍵が残っている可能性がある
- `~/.gnupg/openpgp-revocs.d/` - 鍵生成時に生成される失効証明書が残っている可能性がある

ここに秘密鍵が残ってたら YubiKey に焼いてる意味完全にないですしね。失効証明書に関しても勝手に鍵を無効化されてしまうというリスクがあるので、削除しておきます。

# 各デバイスでの利用法

最後にざっと想定してる利用方法を書いておきます。

## 新しくセットアップする

YubiKey を刺した状態で `gpg --card-edit` を実行し `fetch` コマンドを実行すると、YubiKey に設定した URL of public key から公開鍵がダウンロードされて GPG に登録されます。

```console
$ gpg --card-edit
 
Reader ...........: Yubico YubiKey OTP FIDO CCID
Application ID ...: ********************************
Application type .: OpenPGP
Version ..........: 3.4
Manufacturer .....: Yubico
Serial number ....: ********
Name of cardholder: Alisue
Language prefs ...: ja
Salutation .......: Mr.
URL of public key : https://keys.openpgp.org/vks/v1/by-fingerprint/DF391438E6C2FA2A6398BDEEB11731DAB90A2400
Login data .......: lambdalisue@gmail.com
Signature PIN ....: not forced
Key attributes ...: rsa4096 cv25519 rsa2048
Max. PIN lengths .: 127 127 127
PIN retry counter : 3 0 3
Signature counter : 0
KDF setting ......: on
UIF setting ......: Sign=off Decrypt=off Auth=off
Signature key ....: DF39 1438 E6C2 FA2A 6398  BDEE B117 31DA B90A 2400
      created ....: 2018-04-17 18:03:44
Encryption key....: 054D 6D09 7FAA 332A 8043  11FB E75A 5229 C9C8 C06F
      created ....: 2024-06-23 11:06:41
Authentication key: [none]
General key info..: [none]

gpg/card> fetch
gpg: requesting key from 'https://keys.openpgp.org/vks/v1/by-fingerprint/DF391438E6C2FA2A6398BDEEB11731DAB90A2400'
gpg: key B11731DAB90A2400: public key "Alisue <lambdalisue@gmail.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1

gpg/card> quit
```

その後、対象デバイス専用の副鍵 (Sign) を作成します。副鍵の生成時には YubiKey が必要ですが、（副鍵の秘密鍵をデバイスに残したままにするならば）生成された副鍵を利用時する際は不要なので運用が楽です。**最後の `save` を忘れないように**。

```console
$ gpg --edit-key <鍵ID>
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: ultimate      validity: ultimate
...略...
ssb  cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
     card-no: 0006 16615774
[ultimate] (1). Alisue <lambdalisue@gmail.com>
[ultimate] (2)  Alisue <lambdalisue@hashnote.net>

gpg> addkey
Secret parts of primary key are stored on-card.
Please select what kind of key you want:
   (3) DSA (sign only)
   (4) RSA (sign only)
   (5) Elgamal (encrypt only)
   (6) RSA (encrypt only)
  (10) ECC (sign only)
  (12) ECC (encrypt only)
  (14) Existing key from card
Your selection? 10
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (4) NIST P-384
   (6) Brainpool P-256
Your selection?
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y
Really create? (y/N) y
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.

sec  rsa4096/B11731DAB90A2400
     created: 2018-04-17  expires: never       usage: C
     card-no: 0006 16615774
     trust: ultimate      validity: ultimate
...略...
ssb  cv25519/E75A5229C9C8C06F
     created: 2024-06-23  expires: never       usage: E
     card-no: 0006 16615774
ssb  ed25519/EAC0924129451D73
     created: 2024-06-23  expires: never       usage: S
[ultimate] (1). Alisue <lambdalisue@gmail.com>
[ultimate] (2)  Alisue <lambdalisue@hashnote.net>

gpg> save
```

## Git のコミット署名として利用

Git のコミット署名にはデバイス専用の副鍵 (Sign) を利用します、が、Git の `signingkey` は主鍵の鍵IDを指定すれば良いので、各デバイスで共通の `.gitconfig` を使いまわすことができます。

署名キーに指定する値の調べ方などは [Git へ署名キーを伝える](https://docs.github.com/ja/authentication/managing-commit-signature-verification/telling-git-about-your-signing-key) などを参照すると良さそうです。

# おわり

文中で出てきたリンク以外にも以下の記事などを参考にしました。助かりました。

- [PGP 主鍵を交換した話](https://blog.jj1lfc.dev/posts/pgp-key-transition/)
- [GPG鍵の作成,保存,失効](https://zenn.dev/td_shi/articles/aab416ffd6d696)

GPG 鍵関連、ごく稀にしか作業しない関係で毎回完全に忘れて苦労してますが、先人たちの知恵のお陰で毎度なんとかなっています。この記事も未来の自分と、どこかの誰かの役に立ってくれれば良いなーと思います。

疲れた。

# おまけ

今回は主鍵をすでに持っていたので改変する形にしましたが、新しく主鍵を生成する場合は以下のように行います。

## 主鍵の生成

まず、主鍵を作成します。デフォルトで作ると不要な署名機能がついてしまうので `--expert --full-gen-key` オプションをつけて対話的に選択します。

```console
$ gpg --expert --full-gen-key
gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Please select what kind of key you want:
   (1) RSA and RSA
   (2) DSA and Elgamal
   (3) DSA (sign only)
   (4) RSA (sign only)
   (7) DSA (set your own capabilities)
   (8) RSA (set your own capabilities)
   (9) ECC (sign and encrypt) *default*
  (10) ECC (sign only)
  (11) ECC (set your own capabilities)
  (13) Existing key
  (14) Existing key from card
```

どういった鍵を作るのか聞かれるので `(11) ECC (set your own capabilities)` を選択します。
すると、機能のトグル対話インターフェースに変わるので、署名機能をオフ (`s`) して完了 (`q`) します。

```console
Possible actions for this ECC key: Sign Certify Authenticate
Current allowed actions: Sign Certify

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? s

Possible actions for this ECC key: Sign Certify Authenticate
Current allowed actions: Certify

   (S) Toggle the sign capability
   (A) Toggle the authenticate capability
   (Q) Finished

Your selection? q
```

この先は指示に従ってデフォルトを選択していけば Curve 25519, 有効期限無しな主鍵が生成されます。

```console
Please select which elliptic curve you want:
   (1) Curve 25519 *default*
   (2) Curve 448
   (3) NIST P-256
   (4) NIST P-384
   (5) NIST P-521
   (6) Brainpool P-256
   (7) Brainpool P-384
   (8) Brainpool P-512
   (9) secp256k1
Your selection? 1
Please specify how long the key should be valid.
         0 = key does not expire
      <n>  = key expires in n days
      <n>w = key expires in n weeks
      <n>m = key expires in n months
      <n>y = key expires in n years
Key is valid for? (0)
Key does not expire at all
Is this correct? (y/N) y

GnuPG needs to construct a user ID to identify your key.

Real name: Alisue
Email address: lambdalisue@gmail.com
Comment:
You selected this USER-ID:
    "Alisue <lambdalisue@gmail.com>"

Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? O
We need to generate a lot of random bytes. It is a good idea to perform
some other action (type on the keyboard, move the mouse, utilize the
disks) during the prime generation; this gives the random number
generator a better chance to gain enough entropy.
gpg: revocation certificate stored as '/Users/alisue/.gnupg/openpgp-revocs.d/683F467A1DFC9E414832E0F15CC809CE0D370AAC.rev'
public and secret key created and signed.

pub   ed25519 2024-06-23 [C]
      683F467A1DFC9E414832E0F15CC809CE0D370AAC
uid                      Alisue <lambdalisue@gmail.com>
```

あとは一緒。
