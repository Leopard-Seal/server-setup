#!/bin/bash

# デフォルト値の設定
work_dir=""
remain_active=false

# ヘルプメッセージの表示関数
show_help() {
    echo "使用方法: $0 [-d <work_directory>] [-r] [-h]"
    echo "  -d <work_directory>  作業ディレクトリ名を指定"
    echo "  -r                   仮想環境をアクティブなままにする"
    echo "  -h                   このヘルプメッセージを表示"
}

# オプションの解析
while getopts ":d:rh" opt; do
    case ${opt} in
        d )
            work_dir=$OPTARG
            ;;
        r )
            remain_active=true
            ;;
        h )
            show_help
            exit 0
            ;;
        \? )
            echo "無効なオプション: $OPTARG" 1>&2
            show_help
            exit 1
            ;;
        : )
            echo "オプション -$OPTARG には引数が必要です。" 1>&2
            show_help
            exit 1
            ;;
    esac
done

if [ -z "$work_dir" ]; then
    read -p "作業ディレクトリ名を入力してください: " work_dir
fi

if [ ! -d "$work_dir" ]; then
    mkdir "$work_dir"
    echo "作業ディレクトリ '$work_dir' を作成しました。"
else
    echo "作業ディレクトリ '$work_dir' は既に存在します。"
fi

# 仮想環境ディレクトリを設定
venv_dir="$work_dir/venv"

# 仮想環境ディレクトリが存在しない場合は作成
if [ ! -d "$venv_dir" ]; then
    # Python仮想環境の作成
    python3 -m venv "$venv_dir"
    echo "Python仮想環境を '$venv_dir' に作成しました。"
else
    echo "仮想環境ディレクトリ '$venv_dir' は既に存在します。"
fi

# 仮想環境のアクティベート
source "$venv_dir/bin/activate"
echo "仮想環境をアクティベートしました。"

# pipのアップグレード
pip install --upgrade pip
echo "pipをアップグレードしました。"

# 既存のPyTorchパッケージを削除し、キャッシュをクリア
pip uninstall -y torch torchvision torchaudio
pip cache purge
echo "既存のPyTorchパッケージを削除し、キャッシュをクリアしました。"

# PyTorchの安定版をインストール
pip install torch==2.3.0 torchvision==0.18.0 torchaudio==2.3.0 --index-url https://download.pytorch.org/whl/cu118
echo "PyTorch 2.3.0 (CUDA 11.8) をインストールしました。"

# -r オプションが指定されていない場合は仮想環境を終了
if [ "$remain_active" = false ]; then
    deactivate
    echo "仮想環境を終了しました。"
else
    echo "仮想環境がアクティブなままです。終了するには 'deactivate' を実行してください。"
fi

echo "セットアップが完了しました。"
echo "作業ディレクトリ: $work_dir"
echo "仮想環境ディレクトリ: $venv_dir"