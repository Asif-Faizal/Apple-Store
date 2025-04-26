import express from 'express';
import cors from 'cors';
import productRoutes from './infrastructure/routes/productRoutes';

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api', productRoutes);

// Start server
app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
  console.log(`API endpoints available at http://localhost:${port}/api/products`);
}); 