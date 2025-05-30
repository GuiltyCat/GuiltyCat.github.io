#!/bin/bash
HIST_FILE_NAME="md/0000-00-00.md"
cat <<EOF
私の表現(My Expression)
===============

更新(Updates)
----------

$(tail -n +4 "${HIST_FILE_NAME}" | head -n 10 | sed -e "s/\.\././")
- [全ての履歴(All History)](${HIST_FILE_NAME//md/html})


はじめに
-----------------------

このサイトは私がかきたいと思ったことをただ書いていくものです．

センシティブな内容についても遠慮なく書きます．
ですが，それらは決して誰かを貶めたりする意図で書いたのではありません．
しかし，結果的に誰かを傷付けてしまうかもしれません．
いや，誰かを間違いなく傷付けてしまうでしょう．
無意識に奢りがあり，それが露呈してしまっているのかもしれません．
あるいは，言葉の選び方が悪いのかもしれません．

内容は適宜更新されますが，履歴はGitに残しておきます．

後，私はソースやリンクを貼りませんが，同様に直接引用もしません．
したがって，書いた内容が真実かどうかはまた別の話です．
各自お確かめ下さい．

This site gathers what I want to express.

I will write very sensitve contents.
This not mean that I want to hurt others.
However, I will hurt others someone undesirably.
Some kinds of abundant exist in my unconscious and it appears in my sentense.
Or my word choice causes unbeliavable misleadings.

You can reach history of updates by Git.

I will not link to source of information and will not quote any sentense directoly from other sites.
Thus, you should check by yourself.

自己紹介(Self Introduction)
---------------------

- 某大手電気メーカーに勤める情報系エンジニア/リサーチャー
- C言語が好き
- 思ったことを全て表すために長大な文章を良く書く
- 新しいプログラミング言語とか時々熱が入って作る

- Information System Engineer/Researcher.
- I like C lang.
- I often write very long sentences in order to express all of my thought.
- Sometimes get excited about creating new programming language

内容について
-----------

- 思ったこと
- 技術・理論の話
- 物語
- 絵や漫画，動画

GitHub Pageに絵とか動画はあまり置けないから，
何かいい方法を探してみます．


コメントを書く場所(Comment)
---------------------

まだ運用法については迷い中ですが，
とりあえず全体のコメントはここに設置します．

そして，コメントが多ければ，
個別の記事内にIssueを立て個別管理する予定です．

[コメントを書く場所(Write Comment Here)](https://github.com/GuiltyCat/GuiltyCat.github.io/issues/1)

記事一覧
--------------------

$(for FILE in $(find ./md -type f | sort -n | tac); do
	BASE=$(basename ${FILE%.*})
	MD="./md/${BASE}.md"
	if [[ ! -e "${MD}" ]]; then
		echo -e "${MD}\nsuch file is not exit" >&2
		continue
	fi
	echo "- [${BASE} $(head -n1 ${MD})](html/${BASE}.html)"
done)

EOF
