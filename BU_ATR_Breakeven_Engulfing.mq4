//+------------------------------------------------------------------+
//|                                EA BU ATR BreakEven Engulfing.mq4 |
//|                                  Copyright 2024, BuBat's Trading |
//|                                 https://twitter.com/SyariefAzman |
//+------------------------------------------------------------------+
//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// sourcesatr
#define Version "1.01"                                                       // Define the version of the EA
#property version Version                                                    // Set the version property for the EA
#property link "https://m.me/EABudakUbat"                                    // Link to the EA's support or information page
#property description "This is a ATR BreakEven Engulfing EA "                // Description of the EA
#property description "recommended timeframe M5, choose ranging pair."       // Additional description
#property description " "                                                    // Empty description line
#property description "Recommended using a cent account for 100 usd capital" // Suggestion for account type
#property description " "                                                    // Empty description line
#property description "Join our Telegram channel : t.me/EABudakUbat"         // Link to Telegram channel
#property description "Facebook : m.me/EABudakUbat"                          // Link to Facebook page
#property description "+60194961568 (Budak Ubat)"                            // Contact information
#property icon "\\Images\\bupurple.ico";                                     // Path to the icon for the EA
#property strict                                                             // Enable strict compilation mode
#include <WinUser32.mqh>                                                     // Include Windows user interface library
#include <stdlib.mqh>                                                        // Include standard library for MQL4
#define Copyright "Copyright © 2023, BuBat's Trading"                        // Define copyright information
#property copyright Copyright                                                // Set the copyright property for the EA
//+------------------------------------------------------------------+
//| Name of the EA                                                   |
//+------------------------------------------------------------------+
#define ExpertName "[https://t.me/SyariefAzman] "                    // Define the name of the EA with a link
extern string EA_Name = ExpertName;                                  // Declare an external string variable for the EA name
string Owner = "BUDAK UBAT";                                         // Declare a string variable for the owner's name
string Contact = "WHATSAPP/TELEGRAM : +60194961568";                 // Declare a string variable for contact information
string MB_CAPTION = ExpertName + " v" + Version + " | " + Copyright; // Create a caption for the EA including name, version, and copyright

// Input parameters
extern int MaxLayer = 10;          // Maximum number of layers (orders) allowed
extern double LotSize = 0.01;      // Lot size for each order (keep this declaration)
extern double StopLoss = 100;      // Stop loss in pips
extern double TakeProfit = 20;     // Take profit in pips
extern int RSIPeriod = 14;         // Period for the RSI (Relative Strength Index)
extern double RSIBuy = 70;         // RSI value threshold for buy signals
extern double RSISell = 30;        // RSI value threshold for sell signals
extern int BreakevenPips = 20;     // Number of pips to move to breakeven
extern int TrailingPips = 100;     // Number of pips for trailing stop
extern int MagicNumber = 12345;    // Unique identifier for the EA's orders
extern int ATRPeriod = 14;         // Period for the ATR (Average True Range)
extern double ATRMultiplier = 1.5; // Multiplier for the ATR value

// Global variables
int ticket = 0; // Variable to store the ticket number of the last order

// Function to return authorization message
string AuthMessage()
{
    return ""; // Return an empty string for authorization message (customize as needed)
}

// Function to count buy orders
int CountBuy()
{
    int count = 0; // Initialize count of buy orders to zero
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    { // Loop through all orders from the last to the first
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        { // Select the order by position
            if (OrderType() == OP_BUY && OrderSymbol() == Symbol())
            {            // Check if the order is a buy order for the current symbol
                count++; // Increment the count of buy orders
            }
        }
    }
    return count; // Return the total count of buy orders
}

// Function to count sell orders
int CountSell()
{
    int count = 0; // Initialize count of sell orders to zero
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    { // Loop through all orders from the last to the first
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        { // Select the order by position
            if (OrderType() == OP_SELL && OrderSymbol() == Symbol())
            {            // Check if the order is a sell order for the current symbol
                count++; // Increment the count of sell orders
            }
        }
    }
    return count; // Return the total count of sell orders
}

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit() // Initialization function called when the EA starts
{
    if (TakeProfit <= 0)  // Check if the TakeProfit value is less than or equal to zero
        TakeProfit = 200; // Set a default TakeProfit value if the condition is true
    // Initialization code here (additional setup can be added)
    return (INIT_SUCCEEDED); // Return success status for initialization
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason) // Deinitialization function called when the EA stops
{
    // Deinitialization code here (cleanup can be added)
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick() // Function called on every market tick
{
    if (!newbar())
        return; // Check for a new bar; if not, exit the function

    double rsiValue = iRSI(NULL, 0, RSIPeriod, PRICE_CLOSE, 1); // Get the RSI value for the latest bar
    Print("Current RSI Value: ", rsiValue); // Log the current RSI value

    // Check for bullish engulfing pattern with RSI filter
    if (isBullishEngulfing(1) && rsiValue >= RSIBuy && CountBuy() < MaxLayer)
    {                   // If a bullish engulfing pattern is detected and RSI is above the buy threshold
        Print("Bullish Engulfing detected. Attempting to open a buy order."); // Log the attempt to open a buy order
        OpenBuyOrder(); // Attempt to open a buy order
    }
    else
    {
        Print("No bullish engulfing pattern or conditions not met for buy."); // Log if conditions are not met
    }

    // Check for bearish engulfing pattern with RSI filter
    if (isBearishEngulfing(1) && rsiValue <= RSISell && CountSell() < MaxLayer)
    {                    // If a bearish engulfing pattern is detected and RSI is below the sell threshold
        Print("Bearish Engulfing detected. Attempting to open a sell order."); // Log the attempt to open a sell order
        OpenSellOrder(); // Attempt to open a sell order
    }
    else
    {
        Print("No bearish engulfing pattern or conditions not met for sell."); // Log if conditions are not met
    }

    // Manage trailing stops and breakeven
    ApplyTrailingAndBreakeven(BreakevenPips, TrailingPips); // Call function to apply trailing stop and breakeven
    StopLossManagement();                                   // Manage stop loss for all open positions on every tick

    // Update chart comment
    ChartComment(); // Call function to update the chart comment
}

// Function to check for new bar
bool newbar()
{
    static datetime lastTime = 0;   // Static variable to store the last time a new bar was detected
    datetime currentTime = Time[0]; // Get the current time of the latest bar
    if (currentTime != lastTime)
    {                           // Check if the current time is different from the last recorded time
        lastTime = currentTime; // Update the last time to the current time
        return true;            // Return true indicating a new bar has been detected
    }
    return false; // Return false if no new bar has been detected
}

// Function to check for Bullish Engulfing pattern
bool isBullishEngulfing(int index)
{
    double open1 = iOpen(Symbol(), 0, index + 1);   // Get the open price of the previous bar
    double close1 = iClose(Symbol(), 0, index + 1); // Get the close price of the previous bar
    double open2 = iOpen(Symbol(), 0, index);       // Get the open price of the current bar
    double close2 = iClose(Symbol(), 0, index);     // Get the close price of the current bar

    // Check the conditions for a bullish engulfing pattern
    return (close1 < open1 && close2 > open2 && close2 > open1 && close1 < open2); // Return true if the pattern is detected
}

// Function to check for Bearish Engulfing pattern
bool isBearishEngulfing(int index)
{
    double open1 = iOpen(Symbol(), 0, index + 1);   // Get the open price of the previous bar
    double close1 = iClose(Symbol(), 0, index + 1); // Get the close price of the previous bar
    double open2 = iOpen(Symbol(), 0, index);       // Get the open price of the current bar
    double close2 = iClose(Symbol(), 0, index);     // Get the close price of the current bar

    // Check the conditions for a bearish engulfing pattern
    return (close1 > open1 && close2 < open2 && close2 < open1 && close1 > open2); // Return true if the pattern is detected
}

// Function to open a BUY order
void OpenBuyOrder()
{
    double price = Ask;                     // Get the current ask price
    double sl = price - StopLoss * Point;   // Calculate stop loss price based on the defined stop loss in pips
    double tp = price + TakeProfit * Point; // Calculate take profit price based on the defined take profit in pips

    // Check if LotSize is valid
    if (LotSize < MarketInfo(Symbol(), MODE_MINLOT) || LotSize > MarketInfo(Symbol(), MODE_MAXLOT)) {
        Print("Invalid LotSize: ", LotSize);
        return; // Exit the function if LotSize is invalid
    }

    // Check if StopLoss and TakeProfit are valid
    if (sl < 0 || tp < 0 || (tp - price) < Point || (price - sl) < Point) {
        Print("Invalid StopLoss or TakeProfit values.");
        return; // Exit the function if SL or TP is invalid
    }

    ticket = OrderSend(Symbol(), OP_BUY, LotSize, price, 3, sl, tp, "Buy Order", MagicNumber, 0, clrGreen); // Send a buy order
    if (ticket < 0)
    {                                                       // Check if the order was not successful
        Print("Error opening BUY order: ", GetLastError()); // Print error message with the last error code
    }
    else
    {
        Print("BUY order opened successfully"); // Print success message
    }
}

// Function to open a SELL order
void OpenSellOrder()
{
    double price = Bid;                     // Get the current bid price
    double sl = price + StopLoss * Point;   // Calculate stop loss price based on the defined stop loss in pips
    double tp = price - TakeProfit * Point; // Calculate take profit price based on the defined take profit in pips

    // Check if LotSize is valid
    if (LotSize < MarketInfo(Symbol(), MODE_MINLOT) || LotSize > MarketInfo(Symbol(), MODE_MAXLOT)) {
        Print("Invalid LotSize: ", LotSize);
        return; // Exit the function if LotSize is invalid
    }

    // Check if StopLoss and TakeProfit are valid
    if (sl < 0 || tp < 0 || (price - tp) < Point || (sl - price) < Point) {
        Print("Invalid StopLoss or TakeProfit values.");
        return; // Exit the function if SL or TP is invalid
    }

    ticket = OrderSend(Symbol(), OP_SELL, LotSize, price, 3, sl, tp, "Sell Order", MagicNumber, 0, clrRed); // Send a sell order
    if (ticket < 0)
    {                                                        // Check if the order was not successful
        Print("Error opening SELL order: ", GetLastError()); // Print error message with the last error code
    }
    else
    {
        Print("SELL order opened successfully"); // Print success message
    }
}

// Function: ApplyATRTrailingStop
void ApplyATRTrailingStop(int atrPeriod, double atrMultiplier)
{
    double atrValue = iATR(Symbol(), 0, atrPeriod, 0) * atrMultiplier; // Calculate ATR value and multiply by the defined multiplier
    int trailingPips = (int)(atrValue / Point);                        // Convert ATR value to pips

    for (int i = OrdersTotal() - 1; i >= 0; i--)
    { // Loop through all open orders from the last to the first
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        { // Select the order by position
            if (OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
            {                   // Check if the order belongs to this EA and is for the current symbol
                double newStop; // Variable to hold the new stop loss price
                if (OrderType() == OP_BUY)
                {                                                                  // Check if the order is a buy order
                    newStop = NormalizeDouble(Bid - trailingPips * Point, Digits); // Calculate new stop loss price for buy order
                    if (newStop > OrderStopLoss())
                    {                                                                                                       // Check if the new stop loss is higher than the current stop loss
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), newStop, OrderTakeProfit(), 0, clrNONE); // Modify the order with the new stop loss
                        if (result)
                        {                                                // Check if the modification was successful
                            Print("Trailing stop applied successfully"); // Print success message
                        }
                        else
                        {
                            Print("Failed to apply trailing stop: ", GetLastError()); // Print error message with the last error code
                        }
                    }
                }
                else if (OrderType() == OP_SELL)
                {                                                                  // Check if the order is a sell order
                    newStop = NormalizeDouble(Ask + trailingPips * Point, Digits); // Calculate new stop loss price for sell order
                    if (newStop < OrderStopLoss())
                    {                                                                                                       // Check if the new stop loss is lower than the current stop loss
                        bool result = OrderModify(OrderTicket(), OrderOpenPrice(), newStop, OrderTakeProfit(), 0, clrNONE); // Modify the order with the new stop loss
                        if (result)
                        {                                                // Check if the modification was successful
                            Print("Trailing stop applied successfully"); // Print success message
                        }
                        else
                        {
                            Print("Failed to apply trailing stop: ", GetLastError()); // Print error message with the last error code
                        }
                    }
                }
            }
        }
    }
}

// Function: ApplyTrailingAndBreakeven
void ApplyTrailingAndBreakeven(int breakevenPips, int trailingPips)
{
    // First, move to breakeven
    MoveToBreakeven(breakevenPips); // Call function to move orders to breakeven

    // Then, apply trailing stop
    ApplyATRTrailingStop(ATRPeriod, ATRMultiplier); // Call function to apply trailing stop based on ATR
}

// Function: MoveToBreakeven
void MoveToBreakeven(int breakevenPips)
{
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    { // Loop through all open orders from the last to the first
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        { // Select the order by position
            if (OrderMagicNumber() == MagicNumber && OrderSymbol() == Symbol())
            {                                                              // Check if the order belongs to this EA and is for the current symbol
                double entryPrice = OrderOpenPrice();                      // Get the entry price of the order
                double currentPrice = (OrderType() == OP_BUY) ? Bid : Ask; // Get the current price based on order type
                double distance;                                           // Variable to hold the distance in pips

                if (OrderType() == OP_BUY)
                {                                                   // Check if the order is a buy order
                    distance = (currentPrice - entryPrice) / Point; // Calculate the distance from entry price to current price in pips
                    if (distance >= breakevenPips && OrderStopLoss() < entryPrice)
                    {                                                                                                    // Check if the distance is greater than or equal to breakeven pips and current stop loss is below entry price
                        bool result = OrderModify(OrderTicket(), entryPrice, entryPrice, OrderTakeProfit(), 0, clrNONE); // Modify the order to set stop loss to breakeven
                        if (result)
                        {                                            // Check if the modification was successful
                            Print("Breakeven applied successfully"); // Print success message
                        }
                        else
                        {
                            Print("Failed to apply breakeven: ", GetLastError()); // Print error message with the last error code
                        }
                    }
                }
                else if (OrderType() == OP_SELL)
                {                                                   // Check if the order is a sell order
                    distance = (entryPrice - currentPrice) / Point; // Calculate the distance from entry price to current price in pips
                    if (distance >= breakevenPips && OrderStopLoss() > entryPrice)
                    {                                                                                                    // Check if the distance is greater than or equal to breakeven pips and current stop loss is above entry price
                        bool result = OrderModify(OrderTicket(), entryPrice, entryPrice, OrderTakeProfit(), 0, clrNONE); // Modify the order to set stop loss to breakeven
                        if (result)
                        {                                            // Check if the modification was successful
                            Print("Breakeven applied successfully"); // Print success message
                        }
                        else
                        {
                            Print("Failed to apply breakeven: ", GetLastError()); // Print error message with the last error code
                        }
                    }
                }
            }
        }
    }
}

// Function: StopLossManagement
void StopLossManagement()
{
    double ma_value = iMA(NULL, 0, 30, 0, MODE_SMA, PRICE_CLOSE, 0);    // Calculate the moving average value (SMA) for the last 30 bars
    double sl_diff = 12 * Point;                                        // Define the stop loss distance in pips
    double minStopLevel = MarketInfo(Symbol(), MODE_STOPLEVEL) * Point; // Get the minimum stop level from the broker in pips

    // Loop through all open orders
    for (int i = OrdersTotal() - 1; i >= 0; i--)
    { // Loop through all orders from the last to the first
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {                            // Select the order by position
            double price = Close[0]; // Get the current price (close of the latest bar)

            Print("Processing order ", OrderTicket(), ". Type: ", OrderType(), ". Price: ", price, ". MA: ", ma_value); // Print order details for debugging

            if (OrderType() == OP_BUY)
            { // Check if the order is a buy order
                // Check if price is above the MA before setting SL for Buy
                if (price > ma_value)
                {                                                  // If the current price is above the moving average
                    double new_stop_loss_buy = ma_value - sl_diff; // Calculate new stop loss price for buy order

                    // Ensure the SL is at least minStopLevel away from Ask price
                    if (Ask - new_stop_loss_buy < minStopLevel)
                    {                                           // Check if the new stop loss is too close to the ask price
                        new_stop_loss_buy = Ask - minStopLevel; // Fallback to minimum stop level
                    }

                    // Modify SL if required
                    if (OrderStopLoss() < new_stop_loss_buy || OrderStopLoss() == 0)
                    { // Check if the current stop loss is less than the new stop loss or if it is not set
                        if (new_stop_loss_buy > OrderOpenPrice())
                        { // Ensure the new stop loss is below the open price for buy orders
                            if (OrderModify(OrderTicket(), OrderOpenPrice(), new_stop_loss_buy, OrderTakeProfit(), 0, clrRed))
                            {                                                                      // Modify the order with the new stop loss
                                Print("Stop Loss for Buy Order Adjusted to: ", new_stop_loss_buy); // Print success message
                            }
                            else
                            {
                                Print("Failed to modify Buy order Stop Loss: ", GetLastError()); // Print error message with the last error code
                            }
                        }
                    }
                }
            }
            else if (OrderType() == OP_SELL)
            { // Check if the order is a sell order
                // Check if price is below the MA before setting SL for Sell
                if (price < ma_value)
                {                                                   // If the current price is below the moving average
                    double new_stop_loss_sell = ma_value + sl_diff; // Calculate new stop loss price for sell order

                    // Ensure the SL is at least minStopLevel away from Bid price
                    if (new_stop_loss_sell - Bid < minStopLevel)
                    {                                            // Check if the new stop loss is too close to the bid price
                        new_stop_loss_sell = Bid + minStopLevel; // Fallback to minimum stop level
                    }

                    // Modify SL if required
                    if (OrderStopLoss() > new_stop_loss_sell || OrderStopLoss() == 0)
                    { // Check if the current stop loss is greater than the new stop loss or if it is not set
                        if (new_stop_loss_sell < OrderOpenPrice())
                        { // Ensure the new stop loss is above the open price for sell orders
                            if (OrderModify(OrderTicket(), OrderOpenPrice(), new_stop_loss_sell, OrderTakeProfit(), 0, clrRed))
                            {                                                                        // Modify the order with the new stop loss
                                Print("Stop Loss for Sell Order Adjusted to: ", new_stop_loss_sell); // Print success message
                            }
                            else
                            {
                                Print("Failed to modify Sell order Stop Loss: ", GetLastError()); // Print error message with the last error code
                            }
                        }
                    }
                }
            }
        }
        else
        {
            Print("Failed to select order: ", GetLastError()); // Print error message if order selection fails
        }
    }
}

//+------------------------------------------------------------------+
//| Function to update chart comment                                 |
void ChartComment()
{
    // Get Date String
    datetime Today = StrToTime(StringConcatenate(Year(), ".", Month(), ".", Day())); // Get today's date as a datetime object
    string Date = TimeToStr(TimeCurrent(), TIME_DATE + TIME_MINUTES + TIME_SECONDS); //"yyyy.mm.dd" // Format the current time as a string

    // Prepare the comment
    string comment = StringFormat(
        "\n %s"                 // Print copyright information
        "\n %s"                 // Print date
        "\n %s"                 // Print EA name
        "\n Starting Lot: %.2f" // Print starting lot size
        "\n Equity: $%.2f"      // Print account equity
        "\n Buy: %d | Sell: %d" // Print count of buy and sell orders
        "\n",
        Copyright,                                             // Insert copyright information
        Date,                                                  // Insert date
        EA_Name,                                               // Insert EA name
        LotSize,                                               // Insert starting lot size
        NormalizeDouble(AccountInfoDouble(ACCOUNT_EQUITY), 2), // Insert account equity formatted to two decimal places
        CountBuy(),                                            // Insert count of buy orders
        CountSell()                                            // Insert count of sell orders
    );

    // Display the comment on the chart
    Comment(comment); // Display the prepared comment on the chart
}

// ... Additional functions can be added as needed ...

//+------------------------------------------------------------------+