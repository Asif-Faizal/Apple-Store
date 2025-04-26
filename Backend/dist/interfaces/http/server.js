"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const dotenv_1 = __importDefault(require("dotenv"));
const path_1 = __importDefault(require("path"));
const productService_1 = require("../../application/services/productService");
dotenv_1.default.config();
class Server {
    constructor() {
        this.app = (0, express_1.default)();
        this.port = parseInt(process.env.PORT || '3000', 10);
        this.baseUrl = `http://localhost:${this.port}`;
        this.productService = new productService_1.ProductService(this.baseUrl);
        this.middlewares();
        this.routes();
    }
    middlewares() {
        this.app.use(express_1.default.json());
        this.app.use(express_1.default.urlencoded({ extended: true }));
        const assetsPath = path_1.default.join(__dirname, '../../../assets');
        console.log('Assets path:', assetsPath);
        this.app.use('/assets', (req, res, next) => {
            console.log('Requested path:', req.path);
            console.log('Full file path:', path_1.default.join(assetsPath, req.path));
            express_1.default.static(assetsPath, {
                setHeaders: (res) => {
                    res.set('Cross-Origin-Resource-Policy', 'cross-origin');
                },
                fallthrough: false
            })(req, res, next);
        });
    }
    routes() {
        this.app.get('/api/products', (_req, res) => {
            const products = this.productService.getProductList();
            res.json(products);
        });
        this.app.get('/api/products/:id', (req, res) => {
            const product = this.productService.getProductById(req.params.id);
            if (product) {
                res.json(product);
            }
            else {
                res.status(404).json({ message: 'Product not found' });
            }
        });
        this.app.get('/', (_req, res) => {
            res.json({ message: 'Welcome to Apple Store API' });
        });
    }
    start() {
        this.app.listen(this.port, () => {
            console.log(`Server is running on port ${this.port}`);
            console.log(`Static files are served from: ${path_1.default.join(__dirname, '../../../assets')}`);
        });
    }
}
exports.default = Server;
//# sourceMappingURL=server.js.map