module money(reset,CLK, M0, M1, M2, M3, M4, M5, ti , wi, ci, B1, B2, B3, C1, C2, C3, C4, rr, out, To, Wo, Co, Bo, C, so, RRo);


//module port declaration
input reset;
input CLK;
input M0;
input M1;
input M2;
input M3;
input M4;
input M5;
input ti;
input wi;
input ci;
input B1;
input B2;
input B3;
input C1;
input C2;
input C3;
input C4;
input rr;
output reg [7:0]out;
output reg To;
output reg Wo;
output reg Co;
output reg [2:0]Bo;
output reg [3:0]C;
output reg [9:0]so;
output reg [2:0]RRo;


//module parameter declaration
parameter ONE_DOLLAR = 1, TWO_DOLLAR = 2, FIVE_DOLLAR = 5, TEN_DOLLAR = 10, TWENTY_DOLLAR = 20;
parameter TEA = 5, COOKIES = 20, COFFEE = 7;
parameter CANDIES_TYPE1 = 10, CANDIES_TYPE2 = 20, CANDIES_TYPE3 = 25;
parameter CHOCOLATES_TYPE1 = 30, CHOCOLATES_TYPE2 = 10, CHOCOLATES_TYPE3 = 25, CHOCOLATES_TYPE4= 50;
parameter MAX_TRANSACTION = 3;

reg [1:0]NumTea, NumCookies, NumCoffee;
reg [1:0]NumCandiesType1, NumCandiesType2, NumCandiesType3;
reg [1:0]NumChocolatesType1, NumChocolatesType2, NumChocolatesType3, NumChocolatesType4;
reg [1:0]NumTransaction;
//reg [1:0]NumTenDollar, NumOneDollar, NumTwoDollar, NumFiveDollar;


always @(posedge CLK)
begin
	if (reset) 
		//initial the values of registers
		begin
		out = 0;
		To = 0;
		Wo = 0;
		Co = 0;
		C = 4'b0;
		so = 10'b0;
		Bo = 3'b0;
		RRo = 3'b0;
		NumTea = 2;
		NumCookies = 2;
		NumCoffee = 2;
		NumCandiesType1 = 2;
		NumCandiesType2 = 2;
		NumCandiesType3 = 2;
		NumChocolatesType1 = 2;
		NumChocolatesType2 = 2;
		NumChocolatesType3 = 2;
		NumChocolatesType4 = 2;
		NumTransaction = MAX_TRANSACTION;	
		end
	else
	begin	
		if(rr)
		//it means the remaining money should be returned. The minimum number of coins should be returned.
		//so the remaining money should minus twenty until it is smaller than twenty, then minus ten until it is smaller than ten, 
		//then five, then two, final one until the remain money equals zero.   
		begin
			if(out >= TWENTY_DOLLAR) 
			begin
				out <= out - TWENTY_DOLLAR;
				RRo <= 2;
			end
			else if((out>= TEN_DOLLAR) && (out < TWENTY_DOLLAR)) 
			begin
				out <= out - TEN_DOLLAR;
				RRo <= 1;
			end
			else if((out >= FIVE_DOLLAR) && (out < TEN_DOLLAR)) 
			begin
				out <= out - FIVE_DOLLAR;
				RRo <= 4;
			end
			else if((out >= TWO_DOLLAR) && (out < FIVE_DOLLAR)) 
			begin
				out <= out - TWO_DOLLAR;
				RRo <= 3;
			end
			else if((out >= ONE_DOLLAR) && (out < TWO_DOLLAR)) 
			begin
				out <= out - ONE_DOLLAR;
				RRo <= 5;
			end
			else if(out == 0) 
			begin
				RRo <= 0;
			end
		end
		else
		//if rr is zero, it means that the machining is in the transaction mode.
		//The rest code represents transaction mode. M0, M1, M2, M3 mean $10, $1, $2, $5 are inserted. 
		//M4 and M5 mean credit card and debit card is inserted, respectively.
		begin
			if ((~M4) && (~M5))
			//the begin of transaction using paper bills or coins.
			//Because credit card and debit does not need calculate the value of 'out', M4 and M5 should be excluded first. 
			//We just consider the situation of using paper bills or coins.
			begin
				if (M0)            out <= out + TEN_DOLLAR;// calculate the total money is inserted.
				else if (M1)       out <= out + ONE_DOLLAR;
				else if (M2)       out <= out + TWO_DOLLAR;
				else if (M3)       out <= out + FIVE_DOLLAR;
				else if (ti && (out >= TEA) && NumTransaction) 
				//when customers want tea, the situation should satsify the requirements, 
				//which are than ti is high value, total money is more than tea price and the reamaining number if transaction is more than zero.                  
					begin 
					if (NumTea)//only when the vending machine has tea on sale, customers can buy it.
					begin
					out <= out - TEA;
					To <= 1; 
					NumTea <= NumTea - 1;
					NumTransaction <= NumTransaction - 1;
					end 
					else
					so[0] <= 1; //Otherwise it will output sold out(so).
					end
				else if (wi && (out >= COOKIES) && NumTransaction) //the same as above              
					begin
					if (NumCookies)
					begin
					out <= out - COOKIES;
					Wo <= 1;
					NumCookies <= NumCookies - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[1] <= 1;
					end
				else if (ci && (out >= COFFEE) && NumTransaction)  //the same as above                
					begin
					if (NumCoffee)
					begin
					out <= out - COFFEE;
					Co <= 1;
					NumCoffee <= NumCoffee - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[2] <= 1;
					end
				else if (B1 && (out >= CANDIES_TYPE1) && NumTransaction) //the same as above          
					begin
					if (NumCandiesType1)
					begin
					out <= out - CANDIES_TYPE1;
					Bo[0] <= 1;
					NumCandiesType1 <= NumCandiesType1 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[3] <= 1;
					end
				else if (B2 && (out >= CANDIES_TYPE2) && NumTransaction)  //the same as above         
					begin
					if (NumCandiesType2)
					begin
					out <= out - CANDIES_TYPE2;
					Bo[1] <= 1;
					NumCandiesType2 = NumCandiesType2 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[4] <= 1;
					end
				else if (B3 && (out >= CANDIES_TYPE3) && NumTransaction)  //the same as above         
					begin
					if (NumCandiesType3)
					begin
					out <= out - CANDIES_TYPE3;
					Bo[2] <= 1;
					NumCandiesType3 <= NumCandiesType3 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[5] <= 1;
					end
				else if (C1 && (out >= CHOCOLATES_TYPE1) && NumTransaction)  //the same as above      
					begin
					if (NumChocolatesType1)
					begin
					out <= out - CHOCOLATES_TYPE1;
					C[0] <= 1;
					NumChocolatesType1 = NumChocolatesType1 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
						so[6] <= 1;
					end
				else if (C2 && (out >= CHOCOLATES_TYPE2) && NumTransaction)  //the same as above      
					begin
					if (NumChocolatesType2)
					begin
					out <= out - CHOCOLATES_TYPE2;
					C[1] <= 1;
					NumChocolatesType2 <= NumChocolatesType2 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[7] <= 1;
					end
				else if (C3 && (out >= CHOCOLATES_TYPE3) && NumTransaction)  //the same as above      
					begin
					if (NumChocolatesType3)
					begin
					out <= out - CHOCOLATES_TYPE3;
					C[2] <= 1;
					NumChocolatesType3 <= NumChocolatesType3 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[8] <= 1;
					end
				else if (C4 && (out >= CHOCOLATES_TYPE4) && NumTransaction)  //the same as above      
					begin
					if (NumChocolatesType4)
					begin
					out <= out - CHOCOLATES_TYPE4;
					C[3] <= 1;
					NumChocolatesType4 = NumChocolatesType4 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[9] <= 1;
					end
			end //the end of transaction using paper bills or coins.
			else
			begin //the begin of transaction using credit card of debit card.
				if (ti && NumTransaction) //we just need consider which one the constomer chooses and whether it is up to max number of transaction                 
					begin 
					if (NumTea) //only when the vending machine has tea on sale, customers can buy it.
					begin
					To <= 1; 
					NumTea <= NumTea - 1;
					NumTransaction <= NumTransaction - 1;
					end 
					else
					so[0] <= 1; //Otherwise it will output sold out(so).
					end
				else if (wi && NumTransaction)   //the same as above           
					begin
					if (NumCookies)
					begin
					Wo <= 1;
					NumCookies <= NumCookies - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[1] <= 1;
					end
				else if (ci && NumTransaction)   //the same as above            
					begin
					if (NumCoffee)
					begin
					Co <= 1;
					NumCoffee <= NumCoffee - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[2] <= 1;
					end
				else if (B1 && NumTransaction)  //the same as above      
					begin
					if (NumCandiesType1)
					begin
					Bo[0] <= 1;
					NumCandiesType1 <= NumCandiesType1 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[3] <= 1;
					end
				else if (B2 && NumTransaction)  //the same as above      
					begin
					if (NumCandiesType2)
					begin
					Bo[1] <= 1;
					NumCandiesType2 = NumCandiesType2 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[4] <= 1;
					end
				else if (B3 && NumTransaction)  //the same as above      
					begin
					if (NumCandiesType3)
					begin
					Bo[2] <= 1;
					NumCandiesType3 <= NumCandiesType3 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[5] <= 1;
					end
				else if (C1 && NumTransaction) //the same as above    
					begin
					if (NumChocolatesType1)
					begin
					C[0] <= 1;
					NumChocolatesType1 = NumChocolatesType1 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[6] <= 1;
					end
				else if (C2 && NumTransaction)  //the same as above   
					begin
					if (NumChocolatesType2)
					begin
					C[1] <= 1;
					NumChocolatesType2 <= NumChocolatesType2 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[7] <= 1;
					end
				else if (C3 && NumTransaction)  //the same as above   
					begin
					if (NumChocolatesType3)
					begin
					C[2] <= 1;
					NumChocolatesType3 <= NumChocolatesType3 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[8] <= 1;
					end
				else if (C4 && NumTransaction)  //the same as above   
					begin
					if (NumChocolatesType4)
					begin
					C[3] <= 1;
					NumChocolatesType4 = NumChocolatesType4 - 1;
					NumTransaction <= NumTransaction - 1;
					end
					else
					so[9] <= 1;
					end
			end //the end of transaction using credit card of debit card.
		end
	end
end

endmodule
