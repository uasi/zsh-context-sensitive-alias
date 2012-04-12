#!/bin/zsh

# ロード
source csa.zsh
# またはデバッグモードでロード
#source =(sed 's/#DEBUG//' csa.zsh)

# 初期化
# csa_init を呼んだ後は普通の alias コマンドを使わないこと
csa_init

# コンテキストを更新する関数
function my_context_func {
	local -a ctx
	# Git リポジトリの中にいるなら git コンテキストをセット
	if [[ -n `git rev-parse --git-dir 2> /dev/null` ]]; then
		ctx+=git
	fi
	# Mercurial リポジトリの中にいるなら hg コンテキストをセット
	if [[ -n `hg root 2> /dev/null` ]]; then
		ctx+=hg
	fi
	# コンテキストをセット
	csa_set_context $ctx
}

# コンテキストを更新する関数が cd のたびに呼ばれるようにする
typeset -ga chpwd_functions
chpwd_functions+=my_context_func

# エイリアスを登録
csalias git st 'git status'
csalias hg st 'hg status'
