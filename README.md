# OpenAIGym_noVNC   
Visual Studio CODEを用いて、コマンドベースでgym環境を動かし、動作の様子をブラウザで確認するために作りました。  

## 機能
- sshでコンテナ（Ubuntu18.4)に接続しOpenAIGymを動作させ、GUIをnoVNCを使ってブラウザで表示させることができます。
- `root`と`user`の2つのユーザーが設定されます。  
- `run.sh`でローカルのとコンテナ上のボリュームを共有する設定ができます。  

# Build
```bash:build.sh
docker build --build-arg ROOT_PASSWORD=password -t gym_container:dev .
```  

`ROOT_PASSWORD`にssh接続時に使用するパスワードを設定してください。  

ターミナルで`build.sh`を実行します。  
```bash
$ sh build.sh
```

# Run
`run.sh`を実行します。  
```bash
sh run.sh
```

# ssh経由でコンテナに接続
sshのポートは`run.sh`で`2222`に設定しています。  
```bash:sshで接続
ssh user@localhost -p 2222
```
# ブラウザ上での確認
vncのポートは`run.sh`で`6081`に設定しています。  
HTML5対応ブラウザで `localhost:6081` に接続します。
