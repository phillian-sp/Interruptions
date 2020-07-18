/* Author:   Phillip Miao
   Date:     July 7, 2020
   
   Abstract: This sketch produces generative art that imitates the piece
             Interruptions - Vera Molnár, 1968/69
*/

// Side length of the lines
final int SIDE_LEN = 8;

// distance between 2 lines
final int DIS_BETWEEN = 12;



//Side margin length
final int SIDE_MARGIN = 40;

//Top and bottom margin length
final int TOP_MARGIN = 40;

//The possibility for the line to be horizontal
final float HRO_POSS = 0.3;

// possibility table for determining if the line is visible
// index: the number of neighbors
final float[] INVIS_POSS_TABLE = {0, 0, 0, 0.45, 1, 1, 1, 1, 1};

// the width of border to consider when generating color for each line 
final int LEN_AROUND_CORNER = 2;

// the cut of division for distribution of color
final int DIV_NUM2 = 8;

// Brightness division for HSB 
final int BRIGHT_DIV = DIV_NUM2 + 2;

// Saturation division for HSB 
final float SAT_DIV = BRIGHT_DIV*BRIGHT_DIV;

final float STROKE_WEIGHT = 1.5;

// The possility of visibility for the inital assignment
final float INIT_VISI_POSS = 0.9;


// number of segments horizontally
int xNum;
// number of segments vertically
int yNum;

// turns of colors
final float TURNS = 1;

// Hue division for HSB 
float hueDiv;



void setup()
{
    size(750,750);
    
    // initalize xNum and yNum
    xNum = (int)((width - SIDE_MARGIN * 2) / DIS_BETWEEN) + 1;
    yNum = (int)((height - TOP_MARGIN * 2) / DIS_BETWEEN) + 1;
    
    hueDiv = (xNum+yNum - 2) / TURNS;
    
    colorMode(HSB, (xNum+yNum - 2) / TURNS, SAT_DIV, BRIGHT_DIV);
    strokeWeight(STROKE_WEIGHT);
}

void draw()
{
    // clear the board
    clear();
    background(0,0,0);
    
    // 0 means visible 
    // 1 means invisible
    int[][] isInvisible = new int[xNum + LEN_AROUND_CORNER*2][yNum + LEN_AROUND_CORNER*2];
    
    // Initially assign every cell a visibility
    for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x+= DIS_BETWEEN)
    {
        int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
        for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y+= DIS_BETWEEN)
        {
            int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
            if(random(0,1) > INIT_VISI_POSS) {
                isInvisible[xindex][yindex] = 1;
            }
        }
    }
    
    // Base on the initial assignment, use INVIS_POSS_TABLE to redo the assignment to
    // make sure that invisible lines are in blocks, not scattered
    for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x+= DIS_BETWEEN)
    {
        
        int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
        for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y+= DIS_BETWEEN)
        {
            int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
            int neigs = numOfInvisNeig(isInvisible, xindex, yindex);
            if(random(0,1) < INVIS_POSS_TABLE[neigs]) {
                isInvisible[xindex][yindex] = 1;
            }
        }
    }
    
    // main loop to paint the board
    for(int x = SIDE_MARGIN; x <= width - SIDE_MARGIN; x += DIS_BETWEEN)
    {
        int xindex = (x - SIDE_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER; 
        for(int y = TOP_MARGIN; y <= height - TOP_MARGIN; y += DIS_BETWEEN)
        {
            int yindex = (y - TOP_MARGIN) / DIS_BETWEEN + LEN_AROUND_CORNER;
            
            // if not visible 
            if(isInvisible[xindex][yindex] == 1) {
                continue;
            }
            
            // get the number of invisible neighers 
            int neigs = numOfInvisNeigColor(isInvisible, xindex, yindex);
            
            // set the stroke color
            stroke(coFromNeig(xindex + yindex, neigs));
            
            //*** if want to see the numbers on the board instead of lines
            //fill(coFromNeig(xindex + yindex, neigs));
            
            // main drawing algorithm
            pushMatrix();
            translate(x,y);
            
            // rotate from -PI/2 to PI/2 including HRO_POSS into considering as well
            float randomAngle = random(0,PI/2);
            if(random(0,1) < HRO_POSS)
                randomAngle = -randomAngle;
            rotate(randomAngle);
            
            //*** if want to see the numbers on the board instead of lines
            //text(neigs,0,0);
            line(-SIDE_LEN, -SIDE_LEN, SIDE_LEN, SIDE_LEN);
            popMatrix();
        }
    }
    
    // Stop Looping
    noLoop();
}

/**
 * This function takes in two parameters hue and neigs and returns the corresponding color
 *
 * @param     hue    the hue value for HSB
 *            neigs  the number of neighbors around
 * @return    color  color corresponding to the 2 parameters
 */
color coFromNeig(int hue, int neigs)
{
    
    if(neigs <= DIV_NUM2)
        return color(hue % hueDiv, SAT_DIV - (BRIGHT_DIV-neigs) * (BRIGHT_DIV - neigs), BRIGHT_DIV);
    else
        return color(hue % hueDiv, SAT_DIV, BRIGHT_DIV);
}

/**
 * This function takes in three parameters isVisible, x and y and returns the number of invisible neighbors near the line(x,y)
 *
 * Note: boarder width is 1
 *
 * @param     isVisible    an array indicating the visibility of the graph
 *            x            x-coordinate
 *            y            y-coordinate
 * @return    int          the number of invisible neighbors near the line(x,y)
 */
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

/**
 * This function takes in three parameters isVisible, x and y and returns the number of invisible neighbors near the line(x,y)
 *
 * Note: boarder width is LEN_AROUND_CORNER
 *
 * @param     isVisible    an array indicating the visibility of the graph
 *            x            x-coordinate
 *            y            y-coordinate
 * @return    int          the number of invisible neighbors near the line(x,y)
 */
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
    if(key == ' ')
    {
        loop();
    }
}
