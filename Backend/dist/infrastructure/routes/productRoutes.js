"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const productService_1 = require("../../application/services/productService");
const router = express_1.default.Router();
const productService = new productService_1.ProductService(process.env.BASE_URL || 'http://localhost:3000');
router.get('/products', (_req, res) => {
    try {
        const products = productService.getProductList();
        res.json(products);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch products' });
    }
});
router.get('/products/:id', (req, res) => {
    try {
        const product = productService.getProductDetails(req.params.id);
        if (!product) {
            res.status(404).json({ error: 'Product not found' });
            return;
        }
        res.json(product);
    }
    catch (error) {
        res.status(500).json({ error: 'Failed to fetch product details' });
    }
});
exports.default = router;
//# sourceMappingURL=productRoutes.js.map