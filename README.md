# BU ATR BreakEven Engulfing EA

## Table of Contents
- [Overview](#overview)
- [How It Works](#how-it-works)
  - [Engulfing Pattern Detection](#engulfing-pattern-detection)
  - [RSI Filter](#rsi-filter)
  - [ATR for Volatility Measurement](#atr-for-volatility-measurement)
- [Trade Execution](#trade-execution)
- [Risk Management](#risk-management)
- [Input Parameters](#input-parameters)
- [Usage](#usage)
- [License](#license)
- [Contributing](#contributing)

## Overview
The BU ATR BreakEven Engulfing EA is a trading algorithm for the MetaTrader 4 platform. It leverages the Average True Range (ATR) and the Engulfing candlestick pattern to make informed trading decisions, particularly suited for the M5 timeframe and ranging currency pairs.

## How It Works
The EA analyzes price action and market volatility to identify trading opportunities, focusing on two main components:

### Engulfing Pattern Detection
- **Bullish Engulfing**: Identifies a bullish engulfing pattern, indicating a potential upward reversal.
- **Bearish Engulfing**: Detects a bearish engulfing pattern, suggesting a potential downward reversal.

### RSI Filter
- **Buy Orders**: Only placed if the RSI is above a specified threshold (RSIBuy), indicating the market is not overbought.
- **Sell Orders**: Only placed if the RSI is below a certain level (RSISell), ensuring the market is not oversold.

### ATR for Volatility Measurement
- The EA calculates the ATR over a specified period (ATRPeriod) to determine trailing stops and stop losses.
- The ATR multiplier (ATRMultiplier) allows users to adjust the sensitivity of the trailing stop based on market conditions.

## Trade Execution
When a valid trading signal is identified:
1. **Open Buy Order**: Triggered by a bullish engulfing pattern and favorable RSI condition.
2. **Open Sell Order**: Triggered by a bearish engulfing pattern and favorable RSI condition.
3. **Stop Loss and Take Profit**: Set based on user-defined parameters for effective risk management.

## Risk Management
- **Breakeven Management**: The EA moves the stop loss to the entry price once a trade reaches a specified profit level (BreakevenPips).
- **Trailing Stop**: Adjusts the stop loss based on ATR, allowing it to follow the market price as it moves in favor of the trade.

## Input Parameters
The following parameters can be customized:

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
2. Adjust the input parameters to fit your trading style.
3. The EA will automatically manage trades based on the defined strategy.

## License
This EA is licensed under the MIT License. It is provided for free and should not be sold or distributed for profit. You are free to use, modify, and share this EA, but please respect the terms of the license.

## Contributing
We welcome contributions! If you have ideas for improvements or new features, feel free to fork the repository, make your modifications, and submit a pull request. Your contributions can enhance this EA and benefit the trading community.