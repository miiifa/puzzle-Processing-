import java.util.Random;
import java.util.function.Function;
int nx=30,ny=nx; //ここを毎度cellに変更するのを忘れずに
int w= min(1000,300+40*nx), h= min(800,100+40*ny);
int E= min(600,40*nx);
int e= min(E/nx,40);
int memo[][]= new int[ny][nx]; 
int map[]= new int[ny*nx+1];
int cell[]= new int[nx*ny];
int cnt=0; //何回動かしたか
int set=0;
int ms=0;
int f=0; // パズルが完成したかどうか
int wx,wy; // 現在の空白
int tx,ty; // 目的の空白の位置
int automode=0;
int seed=2;
//int speed=1;
final String FILE_NAME = "save.txt";
String lineData[] = null;
PImage[] imgs= new PImage[nx*ny];
autoCom com;
void mainInfo(){
  for(int y=0; y<ny; y++){
    for(int x=0; x<nx; x++){
      fill(255);
      if(automode==1&&com.used[y*nx+x]==1) fill(100);
      rect(50+x*e, 50+y*e, e, e);
      if(memo[y][x]==0) continue;
      // ここから
      fill(0);
      textSize(e*16/40);
      textAlign(CENTER);
      text(str(memo[y][x]),50+x*e, 60+y*e, e, e);
       //上をコメントアウトしてimage()にする。
      // 画像を写す
      image(imgs[memo[y][x]-1],50+x*e, 50+y*e, e, e);
    }
  }
}
void sideInfo(){
  textAlign(CENTER);
  fill(255);
  rect(w-200, 50, 95, 75);
  rect(w-200, 150, 95, 75);
  rect(w-200, 250, 95, 45);
  fill(0);
  
  // 回数チェッカー
  textSize(16);
  text("steps", w-190, 50, 75, 55);
  textSize(16);
  text(str(cnt),w-185, 75, 60, 45);
  // 経過時間
  textSize(16);
  text("time", w-190, 150, 75, 55);
  textSize(25);
  ms= millis()/1000;
  text(str(ms/60)+":"+str(ms%60),w-228, 180, 150, 100); 
  textSize(25);
  ms= millis()/1000;
  text("auto",w-228, 255, 150, 40); 
}
void move(int xx){
  if(xx%nx!=wx && xx/nx!=wy) return;
  if(xx==wy*nx+wx) return;
  int t=xx/nx, s=xx%nx;
  cnt+= abs(t-wy)+abs(s-wx);
  //delay(1000);
  for(int i=0; i<Math.abs(wx-s);i++){
    if(wx<s) {
      memo[wy][wx+i]= memo[t][wx+i+1];
      map[memo[t][wx+i+1]]= wy*nx+(wx+i);
    }else {
      memo[wy][wx-i]= memo[wy][wx-i-1];
      map[memo[wy][wx-i-1]]= wy*nx+(wx-i);
    }
  }
  for(int i=0; i<Math.abs(wy-t);i++){
    if(wy<t) {
      memo[wy+i][wx]= memo[wy+i+1][wx];
      map[memo[wy+i+1][wx]]= (wy+i)*nx+wx;
    }else {
      memo[wy-i][wx]= memo[wy-i-1][wx];
      map[memo[wy-i-1][wx]]= (wy-i)*nx+wx;
    }
  }
  memo[t][s]= 0;
  map[0]= t*nx+s;
  wx= s; wy= t;
  int ch=0;
  if(set>=nx*ny-4){
    ch=1;
    for(int y=0; y<ny; y++){
      for(int x=0; x<nx; x++){
        if(y==ty && x==tx) continue;
        if(memo[y][x]!=y*nx+x+1) {
          ch=0;
          break;
        }
      }
    }
  }
  if(ch==1) {
    f=1;
    automode=0;
  }
  
}
void makeCell(){
  //for(int i=0; i<ny*nx; i++){
  //   cell[i]= i+1;
  //}
  ////// ここで2枚の絵の組み合わせを持ってくる(int combi[]= new int(nx*ny))
  ////// 今はただのランダム
  //Random random = new Random(seed);
  //for(int i=0; i<ny*nx; i++){
  //  //ランダムの場合
  //    int r= random.nextInt(nx*ny);
  //    int tmp= cell[r];
  //    cell[r]= cell[i];
  //    cell[i]= tmp; 
  //  //組み合わせ(順当)
  //  // cell[i]= combi[i];
  //  //(逆バージョン)
  //  // cell[combi[i]]= i;
  //}
  // 上をコメントアウトしてcell[]にsave.txtをいれる
  lineData= loadStrings( FILE_NAME );
  for(int i=0; i<ny*nx; i++) cell[int(lineData[i])]= i+1;
  if( lineData == null ){
    //読み込み失敗
    println( FILE_NAME + " 読み込み失敗" );
    exit();
  }
  for(int y=0; y<ny; y++){
    for(int x=0; x<nx; x++){
      memo[y][x]= cell[y*nx+x];
      map[cell[y*nx+x]]= y*nx+x;
    }
  }
}

boolean checkPuzzle(){
  // 配列をバブルそーと
  int swap=0;
  for(int i=0; i<nx*ny-1; i++){
    for(int j=nx*ny-1; j>i; j--){
       if(cell[j-1]>cell[j]){
         int tmp= cell[j];
         cell[j]= cell[j-1];
         cell[j-1]= tmp;
         swap++;
       }
     }
  }
  //Random random = new Random();
  // パリティ判定をしながら適切な空白の位置を決定する。
  for(int i=0; i<nx*ny; i++){
    //int i= random.nextInt(nx*ny);
    int space= i;
    int target= memo[i/nx][i%nx]-1;
    if(1>=target%nx && ny-2<=target/nx){
      // 「バブルソートの反復回数の偶奇」と「空白の位置のマンハッタン距離の偶奇」を比較
      if(swap%2==(abs(target/nx-space/nx)+abs(target%nx-space%nx))%2){
        memo[space/nx][space%nx]= 0;
        wy= space/nx; wx= space%nx;
        ty= target/nx; tx= target%nx;
        print("(",wx,wy,")");
        return true;
      }
    }
  }
  return false;
}

void settings(){
  size(w, h);
  
 
}

void setup(){
  smooth();
  for(int i=0; i<nx*ny; i++){
    PImage d= loadImage("./../sketch_2picture/cells/"+String.valueOf(i)+".png");
    imgs[i]= d;
  }
  makeCell();
  while(!checkPuzzle()){
    print("a");
    makeCell(); // 本来は写真の明るさを変える処理
  }
  
  print("fin");
  mainInfo();
  sideInfo();
  //frameRate(-1);
}

void draw(){
  //noLoop();
  //あにめっしょん
   if(automode==1){
      //print(com.now);
      if(com.mode==0) com.auto_move0();
      else if(com.mode==1) com.auto_move1();
      else if(com.mode==2) com.auto_move2();
      else com.auto_move3();
   }
   // for(int i=0; i<ny; i++){
   //   for(int j=0; j<nx; j++){
   //     print(com.used[i*nx+j]," ");
   //   }print("\n");
   // }
   //}
   
  //try{
    

  //  //3秒寝る
  //  //Thread.sleep(speed);
    
  //} catch(InterruptedException ex){
  //  ex.printStackTrace();
  //}
  
  //あにめしょん
  mainInfo();
  if(f==0) sideInfo();
  else {
    mainInfo();
    //sideInfo();
    fill(0);
    text("great!",60, 60+ny*40, 50, 30);
  } 
  
}
void mousePressed(){ 
  if(f==0){
    int x= (mouseX-50)/e, y= (mouseY-50)/e;
    if(50<=mouseX && mouseX<50+e*nx && 50<=mouseY && mouseY<50+e*ny){
      if((wx==x || wy==y) && !(wx==x&&wy==y)){// ずらす処理
        move(y*nx+x);
        if(automode==1){
          com= new autoCom();
        }
      }
    } 
    //rect(w-200, 250, 95, 45);
    if(w-200<=mouseX && mouseX<w-105 && 250<=mouseY && mouseY<295){
      com= new autoCom();
      if(automode==0){
        automode=1;
        print(1,":");
        //-----
        while(f==0){
          if(automode==1){
      //print(com.now);
            if(com.mode==0) com.auto_move0();
            else if(com.mode==1) com.auto_move1();
            else if(com.mode==2) com.auto_move2();
            else com.auto_move3();  
          }
        }
        //------
        print(cnt);
      } else{
        
        automode=0;
        
      }
    }
  }
}
