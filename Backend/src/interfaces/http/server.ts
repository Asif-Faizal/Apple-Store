import express from 'express';
import dotenv from 'dotenv';
import path from 'path';
import { ProductService } from '../../application/services/productService';

dotenv.config();

class Server {
  private app: express.Application;
  private port: number;
  private productService: ProductService;
  private baseUrl: string;

  constructor() {
    this.app = express();
    this.port = parseInt(process.env.PORT || '3000', 10);
    this.baseUrl = `http://127.0.0.1:${this.port}`;
    this.productService = new ProductService(this.baseUrl);
    this.middlewares();
    this.routes();
  }

  private middlewares(): void {
    this.app.use(express.json());
    this.app.use(express.urlencoded({ extended: true }));
    
    // Configure static file serving
    const assetsPath = path.join(__dirname, '../../../assets');
    console.log('Assets path:', assetsPath);
    
    // Serve static files from the assets directory
    this.app.use('/assets', (req, res, next) => {
      // Log the requested path
      console.log('Requested path:', req.path);
      // Log the full file path
      console.log('Full file path:', path.join(assetsPath, req.path));
      
      express.static(assetsPath, {
        setHeaders: (res) => {
          res.set('Cross-Origin-Resource-Policy', 'cross-origin');
        },
        fallthrough: false // Return 404 if file not found
      })(req, res, next);
    });
  }

  private routes(): void {
    // Get all products with minimal data
    this.app.get('/api/products', (_req, res) => {
      const products = this.productService.getProductList();
      res.json(products);
    });

    // Get detailed product by ID
    this.app.get('/api/products/:id', (req, res) => {
      const product = this.productService.getProductById(req.params.id);
      if (product) {
        res.json(product);
      } else {
        res.status(404).json({ message: 'Product not found' });
      }
    });

    // Root route
    this.app.get('/', (_req, res) => {
      res.json({ message: 'Welcome to Apple Store API' });
    });
  }

  public start(): void {
    this.app.listen(this.port, () => {
      console.log(`Server is running on port ${this.port}`);
      console.log(`Static files are served from: ${path.join(__dirname, '../../../assets')}`);
    });
  }
}

export default Server; 