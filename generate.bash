#!/bin/bash

HTML_DIR="./html"
MD_DIR="./md"

function echo_and_do() {
	echo $@
	$@
}

for MD in "${MD_DIR}"/*; do
	FILE=$(basename ${MD%.*})
	HTML="${HTML_DIR}/${FILE}.html"
	echo_and_do pandoc "${MD}" -o "${HTML}"
done

INDEX_MD=$(
	cat <<EOF
GuiltyCat's Home Page
=======================

少し精神を病んでいる人間が思ったことをつらつらと書いたものです．
この記事は何か正解を示すものではありません．
ただある人間がこういう考えをした，というただそれだけのお話です．

A human who has mental sickness writes. 
These article has no truth of world.
Only one stupid human's thought.

私は自己責任という言葉は嫌いですが，
あなたがこれを読み，影響を受け何かをしでかしたとしても，責任は負いません．

I do not like the word "self-responsibility".
However, if you read these, are affected and do something wrong, I will never be responsible.


センシティブな内容についても遠慮なく書くこともあると思います．
それらは決して誰かを貶めたりする意図で書いたのではありません．
誰かを傷つけるつもりで書くことは絶対にありません．

I will write very sensitve contents.
This not mean that I want to hurt others.

しかし，結果的に誰かを傷付けてしまうかもしれません．
いや，誰かを間違いなく傷付けてしまうでしょう．
その時はコメントで教えて下さい．
反論の記事を書いて下さってもかまいません．
リンクはフリーです．

However, I will hurt others someone undesirably.
Please write comments to make menotice or an article for rebuttal.
Link of my articles are free.

無意識に奢りがあり，それが露呈するかもしれません．
あるいは，言葉の選び方が悪く，とんでもない誤解を生んでしまうかもしれません．
それでも書かずにはいられなかったのです．
承認欲求が芽生えてきたのでしょうか．

Some kinds of abundant exist in my unconscious and it appears in my sentense.
Or my word choice causes unbeliavable misleadings.
However, I want to write.
Has Some desire for approval emerged?

内容は適宜更新されますが，履歴はGitに残しておくので，辿れなくなることはないと思います．

You can reach history of updates by Git.


コメントを書く場所(Comment)
=============

- [コメントを書く場所](https://github.com/GuiltyCat/GuiltyCat.github.io/issues)
- [Write Comment Here](https://github.com/GuiltyCat/GuiltyCat.github.io/issues)

記事一覧
================

$(for FILE in "${HTML_DIR}"/*; do
		BASE=$(basename $(echo ${FILE%.*}))
		echo "[${BASE}:$(head -n1 ./${MD_DIR}/${BASE}.md)](${FILE})"
	done)


自己紹介(Self Introduction)
=================================

某大手電気メーカーに勤める情報系エンジニア/リサーチャー
C言語が好き．
思ったことを全て表すために長大な文章を良く書く．

Information System Engineer/Researcher.
I like C lang.
I often write very long article in order to express all of my thought.

EOF
)

echo_and_do pandoc -f markdown -o index.html <(echo "${INDEX_MD}")
