import express, { Router, Request, Response } from 'express';
import { ProductService } from '../../application/services/productService';

const router: Router = express.Router();
const productService = new ProductService(process.env.BASE_URL || 'http://127.0.0.1:3000');

/**
 * @swagger
 * /api/products:
 *   get:
 *     summary: Get list of all products with basic details
 *     description: Returns a list of products with basic information
 *     responses:
 *       200:
 *         description: List of products
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 type: object
 *                 properties:
 *                   id:
 *                     type: string
 *                   name:
 *                     type: string
 *                   type:
 *                     type: string
 *                   price:
 *                     type: number
 *                   isNew:
 *                     type: boolean
 *                   rating:
 *                     type: number
 *                   description:
 *                     type: string
 *                   mainImage:
 *                     type: string
 */
router.get('/products', (_req: Request, res: Response): void => {
  try {
    const products = productService.getProductList();
    res.json(products);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch products' });
  }
});

/**
 * @swagger
 * /api/products/{id}:
 *   get:
 *     summary: Get detailed information about a specific product
 *     description: Returns complete details of a product including all variants and images
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Product ID
 *     responses:
 *       200:
 *         description: Product details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Product'
 *       404:
 *         description: Product not found
 */
router.get('/products/:id', (req: Request<{ id: string }>, res: Response): void => {
  try {
    const product = productService.getProductDetails(req.params.id);
    if (!product) {
      res.status(404).json({ error: 'Product not found' });
      return;
    }
    res.json(product);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch product details' });
  }
});

export default router; 