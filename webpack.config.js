const path = require('path');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './src/index.js',
  mode: "development",
  resolve: {
      fallback: {
          path: false,
          fs: false,
          child_process: false,
          crypto: false,
          url: false,
      },
  },
  output: {
    filename: 'main.js',
    path: path.resolve(__dirname, 'dist'),
  },
  devServer: {
    static: {
      directory: path.join(__dirname, 'dist'),
    },
  },
  plugins: [
    new CopyWebpackPlugin({
      patterns: [
        { from: 'static' },
        { from: 'script' },
      ],
    })
  ],
};
