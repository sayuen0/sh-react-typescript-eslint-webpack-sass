#!/bin/bash
git init
gibo dump Node Sass > .gitignore
git add .gitignore && git commit -m "init"

# yarn start
yarn init -y

# babel
 yarn add -D @babel/core \
    @babel/plugin-external-helpers \
    @babel/plugin-proposal-class-properties \
    @babel/plugin-proposal-object-rest-spread \
    @babel/plugin-transform-runtime \
    @babel/preset-env \
    @babel/preset-react \
    @babel/preset-typescript

# webpack
yarn add -D webpack \
    webpack-cli \
    webpack-dev-server \
    webpack-hot-middleware \
    html-webpack-plugin \
    babel-loader \
    style-loader \
    css-loader \
    sass \
    sass-loader \
    file-loader \
    mini-css-extract-plugin \
    clean-webpack-plugin \
    source-map-loader \
    typescript \
    ts-loader 

# react
yarn add react \
    react-dom \
    @types/react \
    @types/react-dom
    
# router 
yarn add react-router-dom \
    @types/react-router-dom

# eslint prettier pre-commit
yarn add -D eslint \
    eslint-config-prettier \
    eslint-plugin-prettier \
    @typescript-eslint/eslint-plugin \
    @typescript-eslint/parser \
    prettier \
    husky \
    lint-staged

echo """const path = require('path')
const HtmlWebpackPlugin = require('html-webpack-plugin')
const MiniCssExtractPlugin = require('mini-css-extract-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')
module.exports = (env, { mode = 'development' }) => {
  const config = {
    mode,
    entry: './src/Index.tsx',
    output: {
      path: path.resolve(__dirname, 'dist'),
      filename: 'bundle.js',
    },
    devtool: 'source-map',
    resolve: {
      extensions: ['.js', '.jsx', '.ts', '.tsx'],
      alias: { src: path.resolve(__dirname, 'src') },
    },
    module: {
      rules: [
        {
          test: /\.(js|jsx|tsx|ts)$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: [
                '@babel/preset-env',
                '@babel/preset-react',
                '@babel/preset-typescript',
              ],
              plugins: [
                '@babel/plugin-transform-runtime',
                '@babel/plugin-proposal-class-properties',
                '@babel/plugin-proposal-object-rest-spread',
              ],
            },
          },
        },
        {
          loader: 'source-map-loader',
          test: /\.js$/,
          exclude: /node_modules/,
          enforce: 'pre',
        },
        {
          test: /\.scss/,
          use: [
            {
              loader: MiniCssExtractPlugin.loader,
            },
            {
              loader: 'css-loader',
              options: { url: true },
            },
            { loader: 'sass-loader' },
          ],
        },
        {
          test: /\.(png|jpe?g|gif)$/i,
          loader: 'file-loader',
          options: {
            context: path.resolve(__dirname, 'src'),
            name: '[path][name].[ext]',
            outputPath: './',
            publicPath: './',
            useRelativePaths: false,
          },
        },
      ],
    },
    devServer: {
      port: 3000,
    },
    plugins: [
      new CleanWebpackPlugin(),
      new HtmlWebpackPlugin({
        filename: path.resolve(__dirname, 'dist/index.html'),
        template: path.resolve(__dirname, 'src/public', 'index.html'),
      }),
      new MiniCssExtractPlugin({
        filename: 'style.css',
      }),
    ],
  }
  return config
}""" > webpack.config.js

echo '''{
  "extends": "./tsconfig.paths.json",
  "compilerOptions": {
    "outDir": "./dist/",
    "sourceMap": true,
    "noImplicitAny": true,
    "module": "es6",
    "target": "es2015",
    "jsx": "react",
    "strict": true,
    "allowSyntheticDefaultImports": true,
    "forceConsistentCasingInFileNames": true
  },
  "include": [
    "src",
  ],
  "exclude": [
    "node_modules",
    "dist",
  ],
}''' > tsconfig.json

echo '''{
  "compilerOptions": {
    "baseUrl": "src"
  }
}''' > tsconfig.paths.json


mkdir -p src/public
echo """<html>
  <head>
    <title>SampleClient</title>
  </head>
  <body>
    <div id='root'/>
  </body>
</html>
""" > src/public/index.html

echo """import React from 'react'
import ReactDOM from 'react-dom'
import App from 'src/App'
ReactDOM.render(<App />, document.getElementById('root'))
""" > src/Index.tsx

echo """import React from 'react'
import 'src/index.scss'
import { BrowserRouter as Router, Switch, Route, Link } from 'react-router-dom'

export default function App(): JSX.Element {
  return (
    <Router>
      <div>
        <ul>
          <li>
            <Link to="/">Home</Link>
          </li>
          <li>
            <Link to="/about">About</Link>
          </li>
          <li>
            <Link to="/dashboard">Dashboard</Link>
          </li>
        </ul>
        <hr />
        <Switch>
          <Route exact path="/">
            <Home />
          </Route>
          <Route path="/about">
            <About />
          </Route>
          <Route path="/dashboard">
            <Dashboard />
          </Route>
        </Switch>
      </div>
    </Router>
  )
}

function Home() {
  return (
    <div>
      <h2>Home</h2>
    </div>
  )
}

function About() {
  return (
    <div>
      <h2>About</h2>
    </div>
  )
}

function Dashboard() {
  return (
    <div>
      <h2>Dashboard</h2>
    </div>
  )
}""" > src/App.tsx

echo """
body {
  margin: 0px;
  padding: 0px;
  background-image: url("src/img/vase.jpg");
  p {
    color: firebrick;
  }
}
""" > src/index.scss

echo '''{
  "extends": [
    "eslint:recommended",
    "plugin:@typescript-eslint/recommended",
    "plugin:@typescript-eslint/eslint-recommended",
    "plugin:prettier/recommended",
    "prettier/@typescript-eslint"
  ],
  "plugins": [
    "@typescript-eslint",
    "prettier"
  ],
  "parser": "@typescript-eslint/parser",
  "env": { "browser": true, "node": true, "es6": true },
  "parserOptions": {
    "sourceType": "module"
  },
  "rules": {
    "prettier/prettier": [
      "error",
      {
        "trailingComma": "es5",
        "tabWidth": 2,
        "semi": false,
        "singleQuote": true
      }
    ],
    "@typescript-eslint/explicit-function-return-type": "off",
    "@typescript-eslint/array-type": [
      "error",
      {
        "default": "array-simple"
      }
    ],
    "@typescript-eslint/no-var-requires": "off",
    "@typescript-eslint/no-unused-vars": "off",
    "@typescript-eslint/no-explicit-any": "off"
  }
}
''' > .eslintrc.json

# image copy
mkdir -p src/img
cp ~/Downloads/vase.jpg src/img/

# autoclean(after some module installed)
yarn autoclean --init

# finally, add commands
sed -i '' -e '$ d' package.json
echo '''  , "scripts": {
    "start": "webpack serve --open --hot",
    "build": "webpack --mode production",
    "format-autofix": "eslint src --ext .ts,.tsx --fix"
  },
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged"
    }
  },
  "lint-staged": {
    "./**/*.{js,jsx,ts,tsx,json,css,scss,md}": [
      "prettier --write",
      "yarn format-autofix"
    ]
  }
}
''' >> package.json
