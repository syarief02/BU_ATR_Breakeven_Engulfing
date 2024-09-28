# BU ATR BreakEven Engulfing EA

## Table of Contents
- [Download](#download)
- [Overview](#overview)
- [How It Works](#how-it-works)
  - [Engulfing Pattern Detection](#engulfing-pattern-detection)
  - [RSI Filter](#rsi-filter)
  - [ATR for Volatility Measurement](#atr-for-volatility-measurement)
- [Trade Execution](#trade-execution)
- [Risk Management](#risk-management)
- [Input Parameters](#input-parameters)
- [Usage](#usage)
- [Performance](#performance)
- [License](#license)
- [Contributing](#contributing)

## Download
You can download the compiled version of the EA from the following link:

- [Download BU ATR BreakEven Engulfing EA (EX4)](https://github.com/syarief02/BU_ATR_Breakeven_Engulfing/raw/refs/heads/main/BU_ATR_Breakeven_Engulfing.ex4)

## Overview
The BU ATR BreakEven Engulfing EA is a sophisticated trading algorithm designed for the MetaTrader 4 platform. It utilizes the Average True Range (ATR) and the Engulfing candlestick pattern to make informed trading decisions. This EA is particularly suited for the M5 timeframe and is optimized for trading ranging currency pairs, providing traders with a systematic approach to market entry and exit.

## How It Works
The EA analyzes price action and market volatility to identify trading opportunities, focusing on two main components:

### Engulfing Pattern Detection
- **Bullish Engulfing**: This pattern occurs when a smaller bearish candle is followed by a larger bullish candle that completely engulfs the previous candle. It indicates a potential upward reversal, prompting the EA to consider opening a buy order.
- **Bearish Engulfing**: Conversely, this pattern occurs when a smaller bullish candle is followed by a larger bearish candle that engulfs it. This suggests a potential downward reversal, leading the EA to consider opening a sell order.

### RSI Filter
- **Buy Orders**: The EA only places buy orders if the Relative Strength Index (RSI) is above a specified threshold (RSIBuy), ensuring that the market is not overbought and that there is potential for upward movement.
- **Sell Orders**: Similarly, sell orders are only placed if the RSI is below a certain level (RSISell), ensuring that the market is not oversold and that there is potential for downward movement.

### ATR for Volatility Measurement
- The EA calculates the ATR over a specified period (ATRPeriod) to determine trailing stops and stop losses. This allows the EA to adapt to changing market conditions.
- The ATR multiplier (ATRMultiplier) enables users to adjust the sensitivity of the trailing stop based on their risk tolerance and market volatility.

## Trade Execution
When a valid trading signal is identified:
1. **Open Buy Order**: Triggered by a bullish engulfing pattern and favorable RSI condition.
2. **Open Sell Order**: Triggered by a bearish engulfing pattern and favorable RSI condition.
3. **Stop Loss and Take Profit**: These are set based on user-defined parameters, allowing for effective risk management and profit-taking.

## Risk Management
- **Breakeven Management**: The EA moves the stop loss to the entry price once a trade reaches a specified profit level (BreakevenPips). This helps to secure profits and minimize losses.
- **Trailing Stop**: The EA adjusts the stop loss based on ATR, allowing it to follow the market price as it moves in favor of the trade. This dynamic adjustment helps to lock in profits while giving the trade room to grow.

## Input Parameters
The following parameters can be customized to fit individual trading strategies:

| Parameter       | Type    | Description                                                                 |
|------------------|---------|-----------------------------------------------------------------------------|
| `MaxLayer`       | `int`   | Maximum number of open orders allowed.                                      |
| `LotSize`        | `double`| Size of each trade in lots.                                                |
| `StopLoss`       | `double`| Distance in pips for the stop loss.                                        |
| `TakeProfit`     | `double`| Distance in pips for the take profit.                                      |
| `RSIPeriod`      | `int`   | Period for calculating the RSI.                                            |
| `RSIBuy`         | `double`| RSI value above which buy orders are considered.                           |
| `RSISell`        | `double`| RSI value below which sell orders are considered.                          |
| `BreakevenPips`  | `int`   | Number of pips in profit before moving the stop loss to breakeven.        |
| `TrailingPips`   | `int`   | Number of pips for the trailing stop.                                      |
| `MagicNumber`    | `int`   | Unique identifier for the EA's orders.                                     |
| `ATRPeriod`      | `int`   | Period for calculating the ATR.                                            |
| `ATRMultiplier`   | `double`| Multiplier for the ATR to determine trailing stop distance.                |

## Usage
To use the BU ATR BreakEven Engulfing EA:
1. Attach it to a chart in the MetaTrader 4 platform.
2. Adjust the input parameters to fit your trading style and risk tolerance.
3. The EA will automatically manage trades based on the defined strategy, executing trades and managing risk according to the specified parameters.

## Performance
The performance of the BU ATR BreakEven Engulfing EA can vary based on market conditions, the chosen currency pair, and the input parameters. It is recommended to backtest the EA on historical data and demo trade before deploying it on a live account. Regular monitoring and adjustments to the parameters may be necessary to optimize performance.

## License
This EA is licensed under the MIT License. It is provided for free and should not be sold or distributed for profit. You are free to use, modify, and share this EA, but please respect the terms of the license.

## Contributing
We welcome contributions! If you have ideas for improvements or new features, feel free to fork the repository, make your modifications, and submit a pull request. Your contributions can enhance this EA and benefit the trading community.