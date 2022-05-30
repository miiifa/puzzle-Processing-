class autoCom{
  int left=0, right=nx-1;
  int up= 0, down= ny-1;
  int add[]= {-1,nx,1,-nx}; // 隣に行くのにずれる量
  int end; // 終着点
  int state=-1; // 0:上 1:左 2:下 3:右  
  int mode=0;
  int roop=0;
  int aa=0;
  int now; // 今動かす値
  int used[]= new int[nx*ny]; //確定したところ
  autoCom(){
     now= nextEdge();
  }
  int nextEdge(){
    
    int mini= Integer.MAX_VALUE;
    int cost=0;
    int ans=0;
    state=-1;
    // up
    if(ty!=up && abs(up-down)>1){
      cost= abs(wx-right)+abs(wy-up);
      for(int i=right; i>=left; i--){
        int a= abs(map[up*nx+i+1]-up*nx+i)/nx;
        int b= abs(map[up*nx+i+1]-up*nx+i)%nx;
        int c= abs(map[up*nx+i+1]-up*nx+i+1)/nx;
        int d= abs(map[up*nx+i+1]-up*nx+i+1)%nx;
        if(i!=right) cost+= c+d;
        cost+= (min(a,b)*5+abs(a-b)*6);
      }
      if(aa%2==0) cost=0;
      if(cost<mini){
        mini= cost;
        state= 0;
        ans= up*nx+right+1;
        end= up*nx+left+1;
      }
    }
    cost=0;
    
    // left
    if(tx!=left && abs(right-left)>1){
      cost= abs(wx-left)+abs(wy-up);
      for(int i=up; i<=down; i++){
        int a= abs(map[i*nx+left+1]-i*nx+left)/nx;
        int b= abs(map[i*nx+left+1]-i*nx+left)%nx;
        int c= abs(map[i*nx+left+1]-(i-1)*nx+left)/nx;
        int d= abs(map[i*nx+left+1]-(i-1)*nx+left)%nx;
        if(i!=up) cost+= c+d;
        cost+= (min(a,b)*5+abs(a-b)*6);
      }
      
      if(cost<mini){
        mini= cost;
        state= 1;
        ans= up*nx+left+1;
        end= down*nx+left+1;
      } 
    }
    cost=0;
    
    // down
    if(ty!=down && abs(up-down)>1){
      cost= abs(wx-left)+abs(wy-down);
      for(int i=left; i<=right; i++){
        int a= abs(map[down*nx+i+1]-down*nx+i)/nx;
        int b= abs(map[down*nx+i+1]-down*nx+i)%nx;
        int c= abs(map[down*nx+i+1]-down*nx+i-1)/nx;
        int d= abs(map[down*nx+i+1]-down*nx+i-1)%nx;
        if(i!=left) cost+= c+d;
        cost+= (min(a,b)*5+abs(a-b)*6);
      }
      
      if(cost<mini){
        mini= cost;
        state= 2;
        ans= down*nx+left+1;
        end= down*nx+right+1;
      } 
    }
    cost=0;
    
    // right
    if(tx!=right && abs(right-left)>1){
      cost= abs(wx-right)+abs(wy-down);
      for(int i=down; i>=up; i--){
        int a= abs(map[i*nx+right+1]-i*nx+right)/nx;
        int b= abs(map[i*nx+right+1]-i*nx+right)%nx;
        int c= abs(map[i*nx+right+1]-(i+1)*nx+right)/nx;
        int d= abs(map[i*nx+right+1]-(i+1)*nx+right)%nx;
        if(i!=down) cost+= c+d;
        cost+= (min(a,b)*5+abs(a-b)*6);
      }
      if(aa%2==1) cost=0;
      if(cost<mini){
        mini= cost;
        state= 3;
        ans= down*nx+right+1;
        end= up*nx+right+1;
      } 
    }
    aa++;
    print(state);
    if(state==-1){
      // グルグルする処理
      mode=3;
      //print(ans);
    }
    return ans;
  }
  void auto_move0(){ // nowの更新
    
    int to; // 目的の場所
    if(now+add[state]==end) {
      to= end-1; // 最後から2番目
      if(now-1==map[now]&&end-1==map[end]){
        set+=2;
        used[now-1]=1; used[end-1]=1;
        if(state==0) up++;
        else if(state==1) left++;
        else if(state==2) down--;
        else right--;
        now= nextEdge();
        //to= now-1;
      } 
    }
    else if(now==end) to= end-1+add[(state+1)%4]; // 最後
    else to= now-1;
    
    int d1=-1,d2=-1;
    if(map[now]!=to){
      // 1.方向の候補を高々2つ挙げる.(上:0 左:1 下:2 右:3)
      
      if(to/nx<map[now]/nx) d1= 0;
      else if((to/nx>map[now]/nx)) d1= 2;
      
      if(to%nx<map[now]%nx) d2= 1;
      else if(to%nx>map[now]%nx) d2= 3;
      
      // 2.候補の2つのうち操作が少ない方を選び、移動する。
      Movement mv1= new Movement(d1,now,to,used);
      Movement mv2= new Movement(d2,now,to,used);
      if(mv1.testMove()<mv2.testMove()){
        mv1.prodMove();
        //print("方向",d1,"\n");
      }else{
        
        mv2.prodMove();
        //print("方向",d2,"\n");
      }
    }
    //print(now,",",d1,",",d2,"\n");
    // 目的のマスに着いたら隣の値にnowを更新,最後の数字ならぐるっと回し外枠を減らしnow= nextEdge().
    if(map[now]==to) {
      set++;
      used[to]=1;
      if(now!=end){
        now+= add[state];
        // うまくいかないタイミングがある。
        if(now==end && ((map[end]==now-1-add[state]&&wy*nx+wx==now-1+add[(state+1)%4]) || (map[end]==now-1-add[state]+add[(state+1)%4] && wy*nx+wx==now-1-add[state])) || (map[end]==now-1-add[state] && wy*nx+wx!=now-1-add[state]+add[(state+1)%4])){
          set--;
          used[now-1]=0;
          now-= add[state]; // 一個前にもどる。
          mode=2; //例外モード2
          //print("-----------------");
        }
      }else{
        set-=2;
        used[to]= 0;
        used[now-1]=0;
        now-= add[state];
        mode=1;
        
        // ぐるっと回す
        //int x= end-1-add[state];
        //move(x); //進む
        //move(end-1); //押す
        //move(map[end]); //　押す
      }
    }
  }
  void auto_move1(){
    int to= now-1;
    
    int d1=-1,d2=-1;
    // 1.方向の候補を高々2つ挙げる.(上:0 左:1 下:2 右:3)
    if(map[now]!=to){
      if(to/nx<map[now]/nx) d1= 0;
      else if((to/nx>map[now]/nx)) d1= 2;
      
      if(to%nx<map[now]%nx) d2= 1;
      else if(to%nx>map[now]%nx) d2= 3;
      
      // 2.候補の2つのうち操作が少ない方を選び、移動する。
      Movement mv1= new Movement(d1,now,to,used);
      Movement mv2= new Movement(d2,now,to,used);
      if(mv1.testMove()<mv2.testMove()){
        mv1.prodMove();
        //print("方向",d1,"\n");
      }else{
        mv2.prodMove();
        //print("方向",d2,"\n");
      }     
    }
    if(map[now]==to) {
      set++;
      used[now-1]=1;
      
      if(now!=end){
        now+= add[state];
      }else{
        mode=0;
        
        if(state==0) up++;
        else if(state==1) left++;
        else if(state==2) down--;
        else right--;
        now= nextEdge();
      }
    }
  }
  void auto_move2(){
    //print("-----------------");
    int to= now-1+2*add[(state+1)%4];
    int now2= now+add[state];
    int d1=-1,d2=-1;
    // 1.方向の候補を高々2つ挙げる.(上:0 左:1 下:2 右:3)

    if(to/nx<map[now2]/nx) d1= 0;
    else if((to/nx>map[now2]/nx)) d1= 2;
    
    if(to%nx<map[now2]%nx) d2= 1;
    else if(to%nx>map[now2]%nx) d2= 3;
    
    // 2.候補の2つのうち操作が少ない方を選び、移動する。
    Movement mv1= new Movement(d1,now2,to,used);
    Movement mv2= new Movement(d2,now2,to,used);
    if(mv1.testMove()<mv2.testMove()){
      mv1.prodMove();
      //print("方向",d1,"\n");
    }else{
      mv2.prodMove();
      //print("方向",d2,"\n");
    }
    if(map[now2]==to) {
      mode=0;
    }
  }
  void auto_move3(){
    if(roop==0) move(up*nx+left);
    else if(roop==1) move(up*nx+right);
    else if(roop==2) move(down*nx+right);
    else move(down*nx+left);
    roop++;
    roop%=4;
  }
}
