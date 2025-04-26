"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ProductService = void 0;
class ProductService {
    constructor(baseUrl) {
        this.products = [
            {
                id: 'iphone-15',
                name: 'iPhone 15',
                type: 'iPhone',
                basePrice: 799,
                description: 'The latest iPhone with advanced camera system and A16 Bionic chip.',
                rating: 4.8,
                isNew: true,
                mainImage: '/assets/iPhone-15/1.png',
                variants: [
                    {
                        id: 'iphone-15-128gb',
                        name: '128GB',
                        price: 799,
                        color: 'Black',
                        images: ['/assets/iPhone-15/1.png', '/assets/iPhone-15/2.png']
                    },
                    {
                        id: 'iphone-15-256gb',
                        name: '256GB',
                        price: 899,
                        color: 'Blue',
                        images: ['/assets/iPhone-15/3.png', '/assets/iPhone-15/4.png']
                    }
                ]
            },
            {
                id: 'iphone-16',
                name: 'iPhone 16',
                type: 'iPhone',
                basePrice: 899,
                description: 'The next generation iPhone with revolutionary features.',
                rating: 4.9,
                isNew: true,
                mainImage: '/assets/iPhone-16/1.png',
                variants: [
                    {
                        id: 'iphone-16-128gb',
                        name: '128GB',
                        price: 899,
                        color: 'Space Gray',
                        images: ['/assets/iPhone-16/1.png', '/assets/iPhone-16/2.png']
                    },
                    {
                        id: 'iphone-16-256gb',
                        name: '256GB',
                        price: 999,
                        color: 'Silver',
                        images: ['/assets/iPhone-16/3.png', '/assets/iPhone-16/4.png']
                    }
                ]
            },
            {
                id: 'macbook-air',
                name: 'MacBook Air',
                type: 'MacBook',
                basePrice: 999,
                description: 'Incredibly thin and light with the power of M2 chip.',
                rating: 4.7,
                isNew: false,
                mainImage: '/assets/MacBook-Air/1.png',
                variants: [
                    {
                        id: 'macbook-air-13',
                        name: '13-inch',
                        price: 999,
                        color: 'Space Gray',
                        images: ['/assets/MacBook-Air/1.png', '/assets/MacBook-Air/2.png']
                    },
                    {
                        id: 'macbook-air-15',
                        name: '15-inch',
                        price: 1299,
                        color: 'Silver',
                        images: ['/assets/MacBook-Air/3.png', '/assets/MacBook-Air/4.png']
                    }
                ]
            },
            {
                id: 'ipad-pro',
                name: 'iPad Pro',
                type: 'iPad',
                basePrice: 799,
                description: 'Supercharged by M2, the ultimate iPad experience.',
                rating: 4.8,
                isNew: false,
                mainImage: '/assets/iPad-Pro/1.png',
                variants: [
                    {
                        id: 'ipad-pro-11',
                        name: '11-inch',
                        price: 799,
                        color: 'Space Gray',
                        images: ['/assets/iPad-Pro/1.png', '/assets/iPad-Pro/2.png']
                    },
                    {
                        id: 'ipad-pro-13',
                        name: '12.9-inch',
                        price: 1099,
                        color: 'Silver',
                        images: ['/assets/iPad-Pro/3.png', '/assets/iPad-Pro/4.png']
                    }
                ]
            }
        ];
        this.baseUrl = baseUrl;
    }
    getFullImageUrl(path) {
        return `${this.baseUrl}${path}`.replace(/([^:])\/\//g, '$1/');
    }
    processProduct(product) {
        return {
            ...product,
            mainImage: this.getFullImageUrl(product.mainImage),
            variants: product.variants.map(variant => ({
                ...variant,
                images: variant.images.map(image => this.getFullImageUrl(image))
            }))
        };
    }
    getAllProducts() {
        return this.products.map(product => this.processProduct(product));
    }
    getProductById(id) {
        const product = this.products.find(product => product.id === id);
        return product ? this.processProduct(product) : undefined;
    }
    getProductList() {
        return this.products.map(product => ({
            id: product.id,
            name: product.name,
            type: product.type,
            price: product.basePrice,
            isNew: product.isNew,
            rating: product.rating,
            description: product.description,
            mainImage: this.getFullImageUrl(product.mainImage)
        }));
    }
}
exports.ProductService = ProductService;
//# sourceMappingURL=productService.js.map