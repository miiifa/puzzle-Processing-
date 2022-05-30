PImage f1,f2;
PImage g1,g2;
PImage tmp,ma1,ma2;
PImage[] h;
int k,cell=30; //全体300
int data1[],data2[]; // グレースケールの情報を格納 data[y][x]
long dist[][]; // グレースケールの情報を格納 data[y][x]
String savefile1 = "./../sketch_88puzzle/save.txt";
String savefile2 = "./../puzzle_kai/save.txt";
//二枚の画像の大きさを480*480に揃える（理由はまだないのでとりあえず240）
//それぞれ1px＊1pxずつのブロックで比較し距離の最小となるような1px＊1pxを生成
// k*kのマスで8*8 

void settings(){
  f1= loadImage("exp/yogan.png");
  f2= loadImage("exp/mimika.png");
  
  //f1.filter(GRAY);
  //f2.filter(GRAY);
  k= f1.height/cell;
  g1 = createImage(f1.width, f1.height, RGB);
  g2 = createImage(f2.width, f2.height, RGB);
  tmp= createImage(k, k, RGB);
  ma1= createImage(k, k, RGB);
  ma2= createImage(k, k, RGB);
  h= new PImage[cell*cell];
  data1= new int[f1.height*f1.width];
  data2= new int[f2.height*f2.width];
  
  size(f1.width*2, f1.height*2);
}

void setup(){
  image(f1,0,0);
  image(f2,f1.width,0);
  long mcost= Long.MAX_VALUE;
  // グレースケール値を取得
  int rt= 100;
  int x1=21,x2=71;
  //for(int x1=0; x1<=rt; x1++){
  //  for(int x2=0; x2<=rt-x1; x2++){
      int x3= rt-x1-x2;
      
      for(int i=0; i<f1.height*f1.width; i++){
        int x= f1.pixels[i];
        int y= f2.pixels[i];
        
        data1[i]= (int)(((int)(red(x)*0.2126)+(int)(green(x)*0.7152)+(int)(blue(x)*0.0722))*1);
        data2[i]= (int)(((int)(red(y)*0.2126)+(int)(green(y)*0.7152)+(int)(blue(y)*0.0722))*1);
        //g1.pixels[pos]= color((red(data1[y][x])+red(data2[y][x]))/2,(green(data1[y][x])+green(data2[y][x]))/2,(blue(data1[y][x])+blue(data2[y][x]))/2);
        g1.pixels[i]= color(data1[i]);
        g2.pixels[i]= color(data2[i]);
      }
      //image(g1,0,0);
      //image(g2,f1.width,0);
      g1.save("g1.png");
      g2.save("g2.png");

      dist= new long[cell*cell][cell*cell]; // 画像1の各セルから画像2のセルまでの距離を計算
      // 課題1：距離の計算
      // k*kのセルの分け、各々の距離の計算結果をdistに格納
      for(int i=0; i<k; i++){
        for(int j=0; j<k; j++){
          int tmp= k*cell*i+j;
          for(int p1=0; p1<cell*cell; p1++){
            for(int p2=0; p2<cell*cell; p2++){
              int idx1= (p1/cell)*k*k*cell+(p1%cell)*k+tmp;
              int idx2= (p2/cell)*k*k*cell+(p2%cell)*k+tmp;
              long gap= (int)Math.pow(data1[idx1]-data2[idx2],2);
              dist[p1][p2]+= gap;
              
            }
          }
        }
      }
      
      //for(int i=0; i<cell*cell; i++){
      //  for(int j=0; j<cell*cell; j++){
      //    print(dist[i][j],"\n");
      //  }
      //}
      // 課題2：割り当て問題
      Assign as= new Assign(dist);
      int[] ans= as.min_cost_match();
      //for(int i=0; i<cell*cell; i++){
      //  print(i,ans[i],"\n");
      //}
      
      long cost= 0;
      for(int i=0; i<cell*cell; i++){
        cost+= dist[i][ans[i]];
      }
      //print(cost,"\n");
      PImage gr1,gr2,cl1,cl2;
      int pp=130;
        gr1= createImage(300, 300, RGB);
        gr2= createImage(300, 300, RGB);
        cl1= createImage(300, 300, RGB);
        cl2= createImage(300, 300, RGB);
      if(mcost>cost){
      
        for(int i=0; i<cell*cell; i++){
          
          tmp= createImage(k, k, RGB);
          
          for(int s=0; s<k; s++){
            for(int t=0; t<k; t++){
              cl1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]= color((red((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+red(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2,
                                                                          (green((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+green(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2,
                                                                          (blue((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+blue(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2                                                                       
                                                                          );
              gr1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]= color(data2[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]);
              g1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]= color((data1[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]+data2[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t])/2);
              
              cl2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]= color((red(f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t])+red(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2,
                                                                                    (green(f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t])+green(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2, 
                                                                                    (blue(f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t])+blue(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2
                                                                                    );
              g2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]= color((data1[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]+data2[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t])/2);
              gr2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]= color(data1[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]);
              
              //グレー
              tmp.pixels[s*k+t]= color((data1[(i/cell)*(k*(k*cell)) +(i%cell)*k +s*k*cell +t]+data2[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t])/2);
              //カラー
              tmp.pixels[s*k+t]= color((red((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+red(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2,
                                                                          (green((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+green(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2,
                                                                          (blue((f1.pixels[(i/cell)*k*k*cell+(i%cell)*k +s*k*cell +t]))+blue(f2.pixels[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]))/2                                                                       
                                                                          );;
              if(i==pp) ma1.pixels[s*k+t]= color(data1[(i/cell)*(k*(k*cell)) +(i%cell)*k +s*k*cell +t]);
              if(i==pp) ma2.pixels[s*k+t]= color(data2[(ans[i]/cell)*k*k*cell+(ans[i]%cell)*k+s*k*cell +t]);
            }
          }
          h[i]=tmp;
        }
        mcost= cost;
        print(x1,x2,x3,"\n");
        print(mcost,"\n");
      }
  //  }
  //}
  
  print(mcost);
  image(g1,0,0);
  image(g2,f1.height,0);
  image(cl1,0,f1.height);
  //for(int i=0; i<cell; i++){
  //  for(int j=0; j<cell; j++){
  //    image(h[i*cell+j],j*k,i*k+f1.height); //x,y
  //  }
  //}
  image(cl2,f1.width,f1.height);
  // 本研究g1,g2グレー/cl1,cl2はカラー
  cl1.save("結果3.png");
  cl2.save("結果4.png");
  // 先行研究グレー
  gr1.save("結果1.png");
  gr2.save("結果2.png");
  // 合成駒例ma
  h[pp].save("ma.png");
  ma1.save("ma1.png");
  ma2.save("ma2.png");
  for(int i=0; i<cell*cell; i++) h[i].save("./cells/"+i+".png");
  PrintWriter output1 = createWriter(savefile1);
  PrintWriter output2 = createWriter(savefile2);
  for(int i=0; i<cell*cell; i++){
    output1.println(ans[i]);
    output1.flush();
    output2.println(ans[i]);
    output2.flush();
  }
  output1.close();
  output2.close();
}
