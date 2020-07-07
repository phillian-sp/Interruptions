final int SIDE_LEN = 8;
final int DIS_BETWEEN = 12;
final int SIDE_MARGIN = 40;
final int TOP_MARGIN = 40;
final float HRO_POSS = 0.3;
//                             0  1  2  3    4    5  6  7  8
final float[] INVIS_POSS_TABLE = {0, 0, 0, 0.3, 1, 1, 1, 1, 1};
// from dark to light 
final int DIV_COLOR = #e6622e;
//final int[] COLOR_TABLE = {#000000, #451d0d, #8a3a1b, #cf5829, #e6622e, #e87142, #eb8157, #ed916c, #f0a081, #f2b096};
//                         0        1        2        3        4        5        6        7        8        9
final int[] COLOR_TABLE = {#000000, #451d0d, #8a3a1b, #cf5829, #e6622e, #eb8157, #f0a081, #f5c0ab, #f7cfc0, #fadfd5};
final int LEN_AROUND_CORNER = 2;

void setup()
{
    size(750,750);
    background(255);
}

void draw()
{
    clear();
    background(255);
    int xNum = (int)((width - SIDE_MARGIN * 2) / DIS_BETWEEN) + 1;
    int yNum = (int)((height - TOP_MARGIN * 2) / DIS_BETWEEN) + 1;
    
    // 0 means visible 
    // 1 means invisible
    int[][] isVisible = new int[xNum + LEN_AROUND_CORNER*2][yNum + LEN_AROUND_CORNER*2];
    
    for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x+= DIS_BETWEEN)
    {
        int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
        for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y+= DIS_BETWEEN)
        {
            int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
            if(random(0,1) > 0.9) {
                isVisible[xindex][yindex] = 1;
            }
        }
    }
    for(int i = 0; i < 1; i++)
    {
        for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x+= DIS_BETWEEN)
        {
            int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
            for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y+= DIS_BETWEEN)
            {
                int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
                int neigs = numOfInvisNeig(isVisible, xindex, yindex);
                if(random(0,1) < INVIS_POSS_TABLE[neigs]) {
                    isVisible[xindex][yindex] = 1;
                }
            }
        }
    }
    
    
    for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x += DIS_BETWEEN)
    {
        int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
        for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y += DIS_BETWEEN)
        {
            int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
            if(isVisible[xindex][yindex] == 1) {
                //stroke(255,0,0);
                
                continue;
            }
            //else{
                int neigs = numOfInvisNeigColor(isVisible, xindex, yindex);
                stroke(coFromNeig(neigs));
            //}
            
            // main drawing algorithm
            pushMatrix();
            translate(x,y);
            float randomAngle = random(0,PI/2);
            if(random(0,1) < HRO_POSS)
                randomAngle = -randomAngle;
            rotate(randomAngle);
            //text(neigs,0,0);
            line(-SIDE_LEN, -SIDE_LEN, SIDE_LEN, SIDE_LEN);
            popMatrix();
        }
    }
    System.out.println("Finished");
    noLoop();
}

final int DIV_NUM = 8;

color coFromNeig(int neigs)
{
    
    if(neigs <= DIV_NUM) 
        return color(COLOR_TABLE[neigs]);
    else
        return color(COLOR_TABLE[9]);
}


//color cFromNeig(int neigs)
//{
//    return color(light[0] + (dark[0] - light[0]) / 9 * (9-neigs), light[1] + (dark[1] - light[1]) / 9 * (9-neigs), light[2] + (dark[2] - light[2]) / 9 * (9-neigs));
//}

int numOfInvisNeig(int[][] isVisible, int x, int y)
{
    int count = 0;
    for(int i = x - 1; i <= x + 1; i++)
    {
        for(int j = y - 1; j <= y + 1; j++)
        {
            if(i == x && j == y) continue;
            count += isVisible[i][j];
        }
    }
    return count;
}

int numOfInvisNeigColor(int[][] isVisible, int x, int y)
{
    int count = 0;
    for(int i = x - LEN_AROUND_CORNER; i <= x + LEN_AROUND_CORNER; i++)
    {
        for(int j = y - LEN_AROUND_CORNER; j <= y + LEN_AROUND_CORNER; j++)
        {
            if(i == x && j == y) continue;
            count += isVisible[i][j];
        }
    }
    return count;
}
    

void keyPressed()
{
    loop();
}
