#!/bin/bash
cat <<EOF
私の表現
===============

はじめに
-----------------------

このサイトは私がかきたいと思ったことをただ書いていくものです．

This site gathers what I want to express.

センシティブな内容についても遠慮なく書きます．
ですが，それらは決して誰かを貶めたりする意図で書いたのではありません．

I will write very sensitve contents.
This not mean that I want to hurt others.

しかし，結果的に誰かを傷付けてしまうかもしれません．
いや，誰かを間違いなく傷付けてしまうでしょう．

However, I will hurt others someone undesirably.

無意識に奢りがあり，それが露呈してしまっているのかもしれません．
あるいは，言葉の選び方が悪いのかもしれません．

Some kinds of abundant exist in my unconscious and it appears in my sentense.
Or my word choice causes unbeliavable misleadings.

内容は適宜更新されますが，履歴はGitに残しておきます．

You can reach history of updates by Git.

コメントを書く場所(Comment)
---------------------

まだ運用法については迷い中ですが，
とりあえず全体のコメントはここに設置します．

そして，コメントが多ければ，
個別の記事内にIssueを立て個別管理する予定です．

- [コメントを書く場所](https://github.com/GuiltyCat/GuiltyCat.github.io/issues/1)
- [Write Comment Here](https://github.com/GuiltyCat/GuiltyCat.github.io/issues/1)

記事一覧
--------------------

$(for FILE in "./html"/*; do
	BASE=$(basename ${FILE%.*})
	echo "- [${BASE}:$(head -n1 ./md/${BASE}.md)](${FILE})"
done)

自己紹介(Self Introduction)
---------------------

- 某大手電気メーカーに勤める情報系エンジニア/リサーチャー
- C言語が好き
- 思ったことを全て表すために長大な文章を良く書く

- Information System Engineer/Researcher.
- I like C lang.
- I often write very long sentences in order to express all of my thought.
EOF
