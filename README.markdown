# Context-Sensitive Alias for Zsh

特定のコンテキストで有効になるエイリアスを定義できるスクリプトです。

使い方：

    # 初期化
    source csa.zsh
    csa_init
    
    # コンテキストごとにエイリアスを定義
    csalias ctx_git st 'git status'
    csalias ctx_hg st 'hg status'
    
    # コンテキストをセットするとエイリアスが切り替わる
    
    csa_set_context ctx_git
    st
    > # On branch master
    > ...
    
    csa_set_context ctx_hg
    st
    > A file1
    > ? file2
    > ...
    
    csa_set_context ctx_nonexistent
    st
    > zsh: command not found: st

`cd` と同時にコンテキストを変えるなど、より実用的なサンプルについては sample-zshrc.zsh をご覧ください。
