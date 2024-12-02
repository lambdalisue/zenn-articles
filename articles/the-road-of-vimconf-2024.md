---
title: "VimConf 2024 までの道"
emoji: "🍜"
type: "idea" # tech: 技術記事 / idea: アイデア
topics: ["vim", "vimconf"]
published: true
---

どうも、ありすえです。

今回は 2024/11/23 に行われた [VimConf 2024] の参加レポートです。

感想等は他の方に譲って、自分は登壇者しか書けないであろう VimConf 2024 までの流れみたいなのを書いていこうと思います。ここぞとばかりの自分語り乙ですね。

ちなみにスライドは以下です。かなりガッツリスピーカーノートも書いてあるので、興味があれば読んでみてください。

https://bit.ly/3YrU5rU

[VimConf 2024]: https://vimconf.org/2024/

# プロポーザルの提出

![](https://storage.googleapis.com/zenn-user-upload/f11681a538fc-20241202.png)
*マイクロ秒まで指定された揺るぎない締切*

2024/06/29 に VimConf 2024 の登壇者募集が開始されました。

僕は基本的に勉強会は登壇側で参加したいという思いがあるため、今回も登壇者として参加したいと考えていました。
ただ、当時は少し忙しかったこともあり、僕が最初のプロポーザルを出したのはアナウンスから約一ヶ月後の 7/22 でした。

その時の内容はこんな感じです。

> # Title
>
> Can’t Help Falling in Vim ~ Wise men say only fools reinvent the wheel, but I can’t help building yet another fuzzy finder: Fall.vim
>
> # Abstract
>
> TBW

そうです。最初はタイトルだけ書いてアブストは TBW として出していました。社会を舐めたアブストですね。

一応言い訳をさせてもらうと、運営側からの公式発表として「内容は期間内であればいつでも修正できます」と言われていたため、とりあえず「出す」という意思だけを表明した状態でした。

ちなみにタイトルはオッサン世代のアイドルである [Hi-STANDARD] の [Love Is A Battlefield] に収録されている [Can't Help Falling In Love] からもじっています。Elvis の方は意識してません。なお、本番で利用した発表スライドには関連ワードが色々と散りばめてあります。

[Hi-STANDARD]: https://hi-standard.jp/
[Love Is A Battlefield]: https://ja.wikipedia.org/wiki/Love_Is_A_Battlefield
[Can't Help Falling In Love]: https://www.youtube.com/watch?v=HysEWnT1kkc

そして、次の日に頑張ってアブストラクトを埋めて、以下のようなものを出しました。

> # Title
>
> Can’t Help Falling in Vim ~ Wise men say only fools reinvent the wheel, but I can’t help building yet another fuzzy finder: Fall.vim
>
> # Abstract
>
> Hey (´・ω・｀)
> Welcome to Alisue-tei.
> This beer is on the house, so please have a drink and relax.
> 
> Yeah, it’s “Fuzzy Finder again.” Sorry about that.
> They say even a saint has limits, so I’m not expecting forgiveness.
> But when you started reading this abstract, as a member of the Internet Elderly Association, I’m sure you felt a kind of indescribable excitement.
> 
> There are a lot of Fuzzy Finders out there, but there isn’t really one that works with both Vim and Neovim, looks a bit stylish, and is beginner-friendly. Telescope.nvim is Neovim-only, and ddu.vim is a bit too challenging for beginners.
> That’s why I decided to create my own Fuzzy Finder. So today, I’d like to talk about my creation, vim-fall, how it compares to other Fuzzy Finders, the design philosophy behind it, and so on.
> 
> So, what would you like to order?

いちおうアブストラクトの日本語訳はこんな感じです。

> やあ （´・ω・｀)
> ようこそ、ありすえ亭へ。
> このビールはサービスだから、まず飲んで落ち着いて欲しい。
> 
> うん、「また Fuzzy Finder」なんだ。済まない。
> 仏の顔もって言うしね、謝って許してもらおうとも思っていない。
> でも、このアブストラクトを読み始めた時、インターネット老人会に所属している君は、きっと言葉では言い表せない「ときめき」みたいなものを感じてくれたと思う。
> 
> Fuzzy Finder はいっぱいあるけど、実は Vim/Neovim でも動作して、見た目がちょっとイケてて、初学者にも優しいやつってのはないんだ。Telescope.nvim は Neovim 専用だし、ddu.vim は初学者が立ち向かうにはちょっとハードルが高いしね。
> そう思って、僕が思う Fuzzy Finder ってのを作ることにしたんだ。だから、今日は僕の作った vim-fall とほかの Fuzzy Finder との比較とか、設計の思想とか、そういう話をしようと思うんだ。
> 
> じゃぁ、注文を聞こうか。

**社会を舐めたアブストですね**。

一応これでもクスッと笑ってもらいたいなと思って頭を捻って考え出したアブストなんですよ。
いや、嘘です。vim-jp には「*また Fuzzy Finder か*」というミームがあったので、それにあやかって「また〜...」でとっさに思いついたのが[バーボンハウス]だっただけです。

ただ、このアブストを出した時点では「登壇時は絶対『やぁ』から始めるぞ」とか「バーテンダーっぽいコスプレで参加しよう」とか色々考えていました。流石に意味わからないので没にしましたが、冒頭の「やぁ」つながりで [🐴 の被り物して発表しよう](https://www.nicovideo.jp/watch/sm1890440) かなとかも考えてました。おっさん受けは絶対いいので。

まぁ、そんなこんなで色々あって最終的に自己推薦文まで全て埋めて出したのは 8/31 のデッドラインギリギリでした。
一応一ヶ月前にはほぼ完成版を出していて、一ヶ月かけて細かな点と自己推薦文をブラッシュアップした感じです。
もちろん、最悪自己推薦文なくても良いかなという気持ちだったのもありますが、個人的にはもう少し余裕を持って最終盤出せたら良かったなーと思います。

[バーボンハウス]: https://dic.pixiv.net/a/%E3%83%90%E3%83%BC%E3%83%9C%E3%83%B3%E3%83%8F%E3%82%A6%E3%82%B9

# プロポーザルの受理

ありがたいことに、ネタに全振りしているアブストを提出したにも関わらず、受理していただきました。
9/8 にプロポーザルが受理されたことを通知するメールが届き、自己紹介文や X などのリンクを教えてくれと言われた感じです。

ただ、ここで思いもよらない話が舞い込んできます。

![甘えは許さないマンボウ](https://storage.googleapis.com/zenn-user-upload/ebbb6c983ea2-20241202.png)
*甘えは許さないマンボウ*

**なん...だと...**

先に書いた通り、既にプレゼンテーションの入り方から背景画像（バーっぽい画像）や仕込みのネタも考えていたので正直「まじか」という感想でした。
ただ thinca さん（VimConf 準備会）のおっしゃっていることは **100% 正論** であり、**より良い発表を行うための最高のアドバイス** でもあったため、辛酸を嘗める思いで破棄しました（といっても、別になにか用意していたわけではないですが）。

その後、しばらく考えて出てきたのが VimConf 2024 公式ページに乗っている以下のアブストラクトです。

> “Yet another”
>
> We programmers often encounter the phrase “Yet another.” For example, a search for “Yet another” on GitHub will return around 37,000 repositories. Why do programmers love using this phrase so much? Personally, I often use it as a light-hearted excuse, as if to say, “Yes, I know I’m reinventing the wheel.”
>
> Which brings me to what I’ll be discussing at Vimconf 2024: a new “Yet another” fuzzy finder called Fall. Fully aware that I’m reinventing the wheel, I even started Fall’s README with “Yet another.”
>
> Wise men say not to reinvent the wheel, but I can't help doing exactly that. In my presentation, I’ll explore the world of existing fuzzy finders, share what I look for in one, and discuss the design philosophy behind Fall.

一応日本語訳は以下

> 「Yet another」
> 
> 私たちプログラマーは「Yet another」というフレーズに頻繁に出くわします。例えば、GitHubで「Yet another」を検索すると、約37,000のリポジトリが見つかります。なぜプログラマーはこのフレーズをこんなにも好んで使うのでしょうか？個人的には、「そう、車輪の再発明をしているのは分かっているよ」という軽い言い訳として使うことが多いです。
> 
> ここで話をVimconf 2024での発表内容に移しましょう。今回、私が紹介するのはファジーファインダーの新たな「Yet another」、その名も**Fall**です。車輪の再発明をしていることを十分に自覚しているので、FallのREADMEも「Yet another」で始めています。
> 
> 賢者は「車輪を再発明するな」と言いますが、私はどうしてもそれをしてしまうのを止められませんでした。このプレゼンテーションでは、既存のファジーファインダーの世界を探り、私がファジーファインダーに求めるものや、**Fall**の設計思想についてお話しします。

正直ネタという意味ではだいぶパンチは弱くなってしまったかなと思いますが、それでも対象者が「vim-jp に所属しておりバーボンハウスとともに育ったおっさん」から「Yet another という単語を見たことがあるプログラマー」くらいまで広がったので、結果的には良かったかなと思っています。

# スライドの作成

とりあえず僕は夏休みの宿題を初日に終わらせて、あとは遊びまくるタイプの人間です。
今日できることは今日やってしまう。不安をあとに残さない。そういう生き方をしてきています。
そのため、スライドもかなり初期の段階から作成していました、が、そこで問題にぶち当たります。

**スライドを作りながら「なぜ？」を整理すると、現行の Fall は僕が本当に求めている思想とマッチしてないことに気付いてしまいました。**

たとえば Fall は設定を JSON で記述するようにしていましたが、これはどう考えてもプログラマーフレンドリーとは言えません。また、Fall のプラグインは通常の Vim プラグインとして登録するように設計していましたが、これを実現するために、サードパーティプラグインでの型補完などは実現できなくなっていました。

雑な発表で良いのであれば、自分の気持ちに嘘をつき「これが最高なんだよと」発表することは簡単です。でも vim-jp および vim-jp が主体となって開催している VimConf は僕にとってかけがえのないものでした。**そんな VimConf には自分の全力をぶつけたい**。手を抜いた発表はしたくない（アブストはふざけてるけど）という思いが強かったので...

**Fall をフルスクラッチで書き直しました。**

![VimConf 前の怒涛のコミット](https://storage.googleapis.com/zenn-user-upload/b8c8e79f0710-20241202.png)
*VimConf 前の怒涛のコミット*

これはくっっっっっっそ大変でした。もちろん僕は真面目に仕事をしているので、平日は殆ど稼働できません。
家族の了承を得て、休日はフルで Fall の開発と僕の中でふわっとしていた思想の整理、さらにスライドの作成をこなすという日々をしばらく続けました。
子供からベイブレードに誘われようとも「忙しいからごめんね」といって何度も断りを入れました。父親失格ですね。まぁ割と普段からなんですけど。

そんなこんなで、とりあえず満足する形に Fall を仕上げたのが 11/07 で VimConf の約 2 週間前でした。ギリギリですね。
そこからは怒涛のスライド整理を行い、一応最終盤として上げたのが 11/16 でした。まぁ発表練習の結果を下に、そこから色々変えてほぼ前日までブラッシュアップを続けたんですけど。

ブラッシュアップを最終日まで続けるのはいつものことなのですが、流石に発表のネタをフルスクラッチで書き直すという蛮行は初めてでした。
まぁなんとかなるという経験は得られましたが、もう一度やりたいかと言われるとやりたくないですね。胃が痛い。

# VimConf 当日

いよいよ当日です。僕は最後の方のセッションだったので、最初の方のセッションは気楽に聞くことが出来ました。

今回も例年通り同時通訳がありましたが、僕は管理が面倒なので借りませんでした。僕の行動原理は「面倒か否か」なので。
ただ、後日参加した人たちの反応を見ていると、翻訳それ自体がコンテンツになるくらい面白かったみたいなので、この部分は少し後悔しています。
今書いていて思い出したのですが、たぶん前回の VimConf でも全く同じ後悔をしています。忘れっぽいのも問題ですね。

セッションが進み、いよいよ自分の番が近づいてきました。流石に自分の番が近づくと気楽に聞くことなど不可能です。
基本的に僕は Bluesky で実況をしていたのですが、自分の番の前後は実況どころではなく発言が 0 になってました。まぁ、発表を聞いてる余裕など無かったですね。

そして自分の番です。ちなみに、本当は勢いのある発表をしようと考えていたのですが、和服着たイギリス枠が会場をわかせるパフォーマンスをしてしまったので、ここで僕が勢い発表をしても劣化版になってしまいます。
流石に劣化版を演じるのはなぁと思い、急遽 **「しっとり系」** の発表をすることにしました。**決して「ねっとり系」ではありません**。しっとりです。ここ、テストに出ます。

https://x.com/orga_chem/status/1860220806716096932

まぁしっとり系でやると決めたときから覚悟はしていたのですが、ちょっと反応が薄かったのが心残りです。本当はもう少し笑いを取れると良かったのですが、まぁこの辺が実力の限界でしょう。もう、ねっとりでもいいや。

とりあえず、僕の考える Fuzzy Finder とはなにか？何にこだわっているのか？はちゃんと伝えられたかなと思っています。あとは Fall をどんどん進化させて便利にしていくのが大事かなと思っています。なので、今後とも、ねっとりファインダーをよろしくおねがいします。

**エル・プサイ・コングルゥ**

会場に居た人にしか伝わらないでしょうが、これを最後に言わなかったのが一番の心残りです。

# まとめ

**Fall is venry**

あと毎週月曜日のお昼12時に適当に喋ってるのを配信しているので、もしご興味あればよろしくお願いします〜。

https://vim-jp-radio.com/
