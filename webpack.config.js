const path = require('path');

module.exports = {
    entry: {
        dev: {import: './src/index.ts'},
    },
    mode: 'development',
    watch: true,
    module: {
        rules: [
            {
                test: /\.ts$|.js$/,
                use: 'ts-loader',
                exclude: /node_modules/,
            },
        ],
    },
    resolve: {
        extensions: ['.tsx', '.ts', '.js'],
    },
    output: {
        filename: '[name].js',
        path: path.resolve(__dirname, 'bin'),
        libraryTarget: 'umd',
        library: 'dc-devkit',
    },
};
