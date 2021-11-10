const path = require('path');

module.exports = {
    entry: {
        dev: {import: './src/index.ts'},
    },
    mode: 'production',
    watch: true,
    module: {
        rules: [
            {
                test: /\.ts$/,
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
        path: path.resolve(__dirname, 'dist'),
        libraryTarget: 'umd',
        library: 'dcutil',
    },
};
