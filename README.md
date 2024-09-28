# BU_ATR_Breakeven_Engulfing

## Table of Contents
- [Overview](#overview)
- [How It Works](#how-it-works)
  - [Engulfing Pattern Detection](#engulfing-pattern-detection)
  - [RSI Filter](#rsi-filter)
  - [ATR for Volatility Measurement](#atr-for-volatility-measurement)
- [Trade Execution](#trade-execution)
- [Breakeven and Trailing Stop Management](#breakeven-and-trailing-stop-management)
- [Input Parameters](#input-parameters)
- [Customizable Parameters](#customizable-parameters)
- [Usage](#usage)
- [Disclaimer](#disclaimer)

## Overview
The BU ATR BreakEven Engulfing EA is a trading algorithm designed for the MetaTrader 4 platform. It utilizes the Average True Range (ATR) and the Engulfing candlestick pattern to make trading decisions. This EA is particularly suited for the M5 timeframe and is recommended for use with ranging currency pairs.

## How It Works
The EA operates by analyzing price action and market volatility to identify potential trading opportunities. It primarily focuses on two key components: the Engulfing candlestick pattern and the ATR indicator.

### Engulfing Pattern Detection
1. **Bullish Engulfing**: The EA looks for a bullish engulfing pattern, which occurs when a smaller bearish candle is followed by a larger bullish candle that completely engulfs the previous candle. This pattern indicates a potential reversal to the upside.
2. **Bearish Engulfing**: Conversely, the EA identifies a bearish engulfing pattern, where a smaller bullish candle is followed by a larger bearish candle that engulfs it. This pattern suggests a potential reversal to the downside.

### RSI Filter
To enhance the accuracy of its trades, the EA incorporates the Relative Strength Index (RSI) as a filter:
- **Buy Orders**: The EA will only place buy orders if the RSI value is above a specified threshold (RSIBuy), indicating that the market is not overbought.
- **Sell Orders**: Similarly, sell orders are only placed if the RSI is below a certain level (RSISell), ensuring that the market is not oversold.

### ATR for Volatility Measurement
The Average True Range (ATR) is used to measure market volatility:
- The EA calculates the ATR over a specified period (ATRPeriod) and uses this value to determine the distance for trailing stops and stop losses.
- The ATR multiplier (ATRMultiplier) allows users to adjust the sensitivity of the trailing stop based on market conditions.

## Trade Execution
When the EA identifies a valid trading signal based on the engulfing pattern and RSI filter, it executes the following steps:
1. **Open Buy Order**: If a bullish engulfing pattern is detected and the RSI condition is met, the EA opens a buy order with a specified lot size.
2. **Open Sell Order**: If a bearish engulfing pattern is detected and the RSI condition is met, the EA opens a sell order.
3. **Stop Loss and Take Profit**: The EA sets the stop loss and take profit levels based on user-defined parameters, ensuring risk management is in place.

## Breakeven and Trailing Stop Management
- **Breakeven Management**: Once a trade moves a specified number of pips in profit (BreakevenPips), the EA automatically adjusts the stop loss to the entry price, securing the trade against potential losses.
- **Trailing Stop**: The EA applies a trailing stop based on the ATR, allowing the stop loss to follow the market price as it moves in favor of the trade. This helps to lock in profits while giving the trade room to grow.

## Input Parameters
The following input parameters are available for customization:

- **MaxLayer**: 
  - **Type**: `int`
  - **Description**: Maximum number of open orders allowed. This parameter helps to limit the number of concurrent trades, preventing overexposure in the market.

- **LotSize**: 
  - **Type**: `double`
  - **Description**: Size of each trade in lots. This parameter determines the volume of each trade and affects the potential profit or loss.

- **StopLoss**: 
  - **Type**: `double`
  - **Description**: Distance in pips for the stop loss. This parameter sets the maximum loss allowed on a trade before it is automatically closed.

- **TakeProfit**: 
  - **Type**: `double`
  - **Description**: Distance in pips for the take profit. This parameter defines the target profit level at which the trade will be closed automatically.

- **RSIPeriod**: 
  - **Type**: `int`
  - **Description**: Period for calculating the RSI. This parameter determines how many bars are used to calculate the RSI value, affecting the sensitivity of the indicator.

- **RSIBuy**: 
  - **Type**: `double`
  - **Description**: RSI value above which buy orders are considered. This parameter helps to filter out overbought conditions, ensuring that buy orders are placed only when the market is favorable.

- **RSISell**: 
  - **Type**: `double`
  - **Description**: RSI value below which sell orders are considered. This parameter helps to filter out oversold conditions, ensuring that sell orders are placed only when the market is favorable.

- **BreakevenPips**: 
  - **Type**: `int`
  - **Description**: Number of pips in profit before moving the stop loss to breakeven. This parameter helps to secure trades by minimizing potential losses once a certain profit level is reached.

- **TrailingPips**: 
  - **Type**: `int`
  - **Description**: Number of pips for the trailing stop. This parameter determines how far the market price must move in favor of the trade before the stop loss is adjusted.

- **MagicNumber**: 
  - **Type**: `int`
  - **Description**: Unique identifier for the EA's orders. This parameter helps to distinguish orders placed by this EA from others in the trading account.

- **ATRPeriod**: 
  - **Type**: `int`
  - **Description**: Period for calculating the ATR. This parameter determines how many bars are used to calculate the ATR value, affecting the sensitivity of the volatility measurement.

- **ATRMultiplier**: 
  - **Type**: `double`
  - **Description**: Multiplier for the ATR to determine trailing stop distance. This parameter allows users to adjust the trailing stop distance based on market volatility.

## Customizable Parameters
Users can adjust various parameters such as lot size, stop loss, take profit, RSI periods, and ATR settings to tailor the EA to their trading strategy.

## Usage
To use the BU ATR BreakEven Engulfing EA, simply attach it to a chart in the MetaTrader 4 platform. Adjust the input parameters as needed to fit your trading style. The EA will automatically manage trades based on the defined strategy.

## Disclaimer
Trading in financial markets involves risk. Ensure you understand the risks involved and consider seeking advice from a financial advisor if necessary.