---
mode: ask
---

これまでの会話で学んだことを整理します。

## 1. GitHub Actions の基礎

**基本構造:**
```
Workflow (YAMLファイル)
  └─ Jobs (並列/順次実行可能)
      └─ Steps (順次実行)
```

**重要な用語:**
- `on:` - トリガー（push, pull_request, workflow_dispatchなど）
- `runs-on:` - 実行環境（ubuntu-latest など）
- `uses:` - 既製品のAction（他の人が作った処理）
- `run:` - 自分で書くコマンド
- `needs:` - ジョブの依存関係
- `strategy.matrix:` - 複数パターンの並列実行

## 2. 実際に作成したもの

**プロジェクト構成:**
```
/workspaces/ruby-test-workflow/
├── .github/workflows/
│   └── ci.yml              # CI ワークフロー
├── spec/
│   ├── hello_spec.rb       # Minitest テスト
│   └── spec_helper.rb      # テスト設定
├── hello.rb                # メインクラス
├── Gemfile                 # 依存管理
└── .rubocop.yml            # RuboCop設定
```

**CI Workflow の構成:**
1. **Lintジョブ**: RuboCop でコード品質チェック
2. **Testジョブ**: Ruby 3.2, 3.3, 3.4 で並列テスト
3. 依存関係: Lint成功後にTestを実行

## 3. GitHub Actions の構文

**`${{ }}`式:**
- GitHub Actionsの専用構文
- YAMLレベルで展開される
- 例: `${{ matrix.ruby }}`, `${{ env.RUBY_VERSION }}`

**コンテキスト:**
- `github.*` - リポジトリ情報（`github.ref`, `github.actor`）
- `matrix.*` - matrixで定義した値
- `env.*` - 環境変数
- `secrets.*` - 機密情報
- `needs.*` - 前のジョブの出力

**環境変数の3レベル:**
```yaml
env:                    # 1. Workflowレベル（全体）
  GLOBAL: 'value'

jobs:
  test:
    env:                # 2. Jobレベル（ジョブ内）
      JOB_VAR: 'value'
    steps:
      - run: echo "test"
        env:            # 3. Stepレベル（ステップ内）
          STEP_VAR: 'value'
```

## 4. Ruby 開発環境

**Minitest:**
- Rubyに標準で含まれる（gem install不要）
- シンプルなテストフレームワーク
- 実行: `ruby -Ilib:spec spec/hello_spec.rb`

**RuboCop:**
- コードスタイルチェッカー
- VS Code + Ruby LSPで自動チェック・修正
- 実行: `bundle exec rubocop`

**Bundler:**
- Gemfile で依存管理
- `bundler-cache: true` でGitHub Actionsで自動キャッシュ
- 実行: `bundle exec <command>`

## 5. Ruby 3.4 の特徴

**`frozen_string_literal`:**
- Ruby 3.4でも**デフォルトではfalse**
- 明示的に `# frozen_string_literal: true` が必要
- Ruby 4.0で将来的にデフォルトtrueになる予定

## 6. GitHub Actions の制限

**無料アカウント:**
- パブリックリポジトリ: 無制限
- プライベートリポジトリ: 月2,000分
- 1ジョブあたり: 最大6時間
- アーティファクト: 2GB
- キャッシュ: 10GB

## 7. 実践的なパターン

**ジョブ分離:**
```yaml
jobs:
  lint:
    # コード品質チェック
  test:
    needs: lint  # lintが成功してから実行
    # テスト実行
```

**マトリックステスト:**
```yaml
strategy:
  fail-fast: false
  matrix:
    ruby: ['3.2', '3.3', '3.4']
```

**キャッシュ活用:**
```yaml
- uses: ruby/setup-ruby@v1
  with:
    bundler-cache: true  # Gemfile.lockベースで自動キャッシュ
```

## 8. ローカルとリモートの統一

**同じコマンドで実行可能:**
```bash
# ローカル
bundle exec rubocop
bundle exec ruby -Ilib:spec spec/hello_spec.rb

# GitHub Actions
run: bundle exec rubocop
run: bundle exec ruby -Ilib:spec spec/hello_spec.rb
```

## 次に学べること

まだ触れていない実践的な機能:
- **Artifacts**: テスト結果の保存・ダウンロード
- **Secrets**: 機密情報の安全な管理
- **条件分岐**: `if:` による実行制御
- **再利用可能Workflow**: `workflow_call`
- **スケジュール実行**: `schedule:`（cron）
- **手動実行**: `workflow_dispatch` with inputs
- **カバレッジ測定**: SimpleCov など
