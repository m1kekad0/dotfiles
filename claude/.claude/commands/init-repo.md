---
allowed-tools: Bash(git init:*), Bash(git add:*), Bash(git commit:*), Bash(git branch:*), Bash(git remote:*), Bash(git push:*), Bash(gh repo create:*), Bash(mkdir:*), Bash(ls:*), Bash(test:*), Bash(cat:*)
description: 新しいディレクトリを作成し git init → 初期ファイル作成 → GitHub private リポジトリ作成 → push まで一括実行する
---

## 入力

`$ARGUMENTS` にリポジトリ名が渡される。

## あなたのタスク

以下の手順を **順番通り** に実行すること。途中でエラーが発生した場合はユーザーに報告して停止すること。

### 1. 引数バリデーション

`$ARGUMENTS` が空の場合は以下を出力して **即座に停止** すること：

```
使い方: /init-repo <リポジトリ名>
例:    /init-repo my-new-project
```

`$ARGUMENTS` が正規表現 `^[A-Za-z0-9][A-Za-z0-9._-]*$` に一致しない場合、または `$ARGUMENTS` に `..` が含まれる場合は、以下を出力して **即座に停止** すること：

```
リポジトリ名には、先頭が英数字で、英数字・ピリオド・アンダースコア・ハイフンのみ使用できます。連続するピリオドは使用できません。
```

パス区切り、空白、`..`、先頭がピリオドまたはハイフンの名前は許可しないこと。

### 2. ディレクトリ存在確認

引数のバリデーションに成功した後、同名のファイルまたはディレクトリが存在しないことを確認する。コマンドが終了コード 1 を返した場合は既に存在するため、ユーザーに報告して停止すること。

```bash
test ! -e "$ARGUMENTS"
```

### 3. ディレクトリ作成 & git 初期化

```bash
mkdir -- "$ARGUMENTS"
cd -- "$ARGUMENTS"
git init -b main
```

### 4. README.md 作成

以下の内容で `README.md` を作成すること（`$ARGUMENTS` をリポジトリ名として使用）：

```markdown
# $ARGUMENTS
```

### 5. .gitignore 作成

汎用的な .gitignore を作成すること。内容は以下を含めること：
- OS 系（.DS_Store, Thumbs.db）
- エディタ系（.idea/, .vscode/, *.swp）
- 環境変数（.env, .env.local）
- 依存関係（node_modules/, vendor/）
- ビルド成果物（dist/, build/, *.o, *.out）

### 6. 初期コミット

```bash
git add README.md .gitignore
git commit -m "Initial commit"
```

### 7. GitHub private リポジトリ作成 & push

```bash
gh repo create m1kekad0/"$ARGUMENTS" --private --source=. --remote=origin --push
```

### 8. 完了報告

すべて成功したら以下を日本語で報告すること：
- 作成したディレクトリパス
- GitHub リポジトリ URL
- 作成されたファイル一覧
