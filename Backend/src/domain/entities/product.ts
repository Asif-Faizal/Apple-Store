export interface ProductVariant {
  id: string;
  name: string;
  price: number;
  color: string;
  images: string[];
}

export interface Product {
  id: string;
  name: string;
  type: 'iPhone' | 'iPad' | 'MacBook';
  basePrice: number;
  description: string;
  rating: number;
  isNew: boolean;
  mainImage: string;
  variants: ProductVariant[];
} 