export interface ProductVariant {
  id: string;
  name: string;
  price: number;
  color: string;
}

export interface Product {
  id: string;
  name: string;
  type: 'iPhone' | 'iPad' | 'MacBook';
  basePrice: number;
  description: string;
  fullDescription: string;
  rating: number;
  isNew: boolean;
  mainImage: string;
  images: string[];
  variants: ProductVariant[];
} 