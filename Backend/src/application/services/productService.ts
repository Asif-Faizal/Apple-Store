import { Product, ProductVariant } from '../../domain/entities/product';

export class ProductService {
  private baseUrl: string;

  constructor(baseUrl: string) {
    this.baseUrl = baseUrl;
  }

  private getFullImageUrl(path: string): string {
    // Remove any double slashes except after http:
    return `${this.baseUrl}${path}`.replace(/([^:])\/\//g, '$1/');
  }

  private products: Product[] = [
    {
      id: 'iphone-15',
      name: 'iPhone 15',
      type: 'iPhone',
      basePrice: 799,
      description: 'The latest iPhone with advanced camera system and A16 Bionic chip.',
      fullDescription: 'Experience the power of iPhone 15 with its advanced camera system featuring a 48MP main camera, A16 Bionic chip for incredible performance, and a stunning 6.1-inch Super Retina XDR display. The Ceramic Shield front cover is tougher than any smartphone glass, and the aerospace-grade aluminum design is both beautiful and durable. With all-day battery life and 5G connectivity, iPhone 15 is ready for anything.',
      rating: 4.8,
      isNew: true,
      mainImage: '/assets/iPhone-15/1.png',
      images: ['/assets/iPhone-15/1.png', '/assets/iPhone-15/2.png', '/assets/iPhone-15/3.png', '/assets/iPhone-15/4.png'],
      variants: [
        {
          id: 'iphone-15-128gb',
          name: '128GB',
          price: 799,
          color: 'Black',
        },
        {
          id: 'iphone-15-256gb',
          name: '256GB',
          price: 899,
          color: 'Blue',
        }
      ]
    },
    {
      id: 'iphone-16',
      name: 'iPhone 16',
      type: 'iPhone',
      basePrice: 899,
      description: 'The next generation iPhone with revolutionary features.',
      fullDescription: 'Introducing iPhone 16 - the future of smartphones. Featuring a revolutionary 6.7-inch Always-On ProMotion display, the powerful A17 Pro chip, and an advanced camera system with 48MP main camera and enhanced Night mode. The titanium design is both lightweight and durable, while the new Action button provides quick access to your favorite features. With improved battery life and next-generation 5G connectivity, iPhone 16 sets a new standard for mobile technology.',
      rating: 4.9,
      isNew: true,
      mainImage: '/assets/iPhone-16/1.png',
      images: ['/assets/iPhone-16/1.png', '/assets/iPhone-16/2.png', '/assets/iPhone-16/3.png', '/assets/iPhone-16/4.png'],
      variants: [
        {
          id: 'iphone-16-128gb',
          name: '128GB',
          price: 899,
          color: 'Space Gray',
        },
        {
          id: 'iphone-16-256gb',
          name: '256GB',
          price: 999,
          color: 'Silver',
        }
      ]
    },
    {
      id: 'iphone-16-pro',
      name: 'iPhone 16 Pro',
      type: 'iPhone',
      basePrice: 999,
      description: 'The most powerful iPhone ever with pro-level features.',
      fullDescription: 'iPhone 16 Pro represents the pinnacle of smartphone technology. Featuring a stunning 6.7-inch Super Retina XDR display with ProMotion, the revolutionary A17 Pro chip with 6-core GPU, and a pro camera system with 48MP main camera, 12MP Ultra Wide, and 12MP Telephoto with 3x optical zoom. The titanium design is both elegant and durable, while the new Action button and USB-C port provide enhanced functionality. With all-day battery life and advanced 5G connectivity, iPhone 16 Pro is the ultimate device for professionals and power users.',
      rating: 4.9,
      isNew: true,
      mainImage: '/assets/iPhone-16-Pro/1.png',
      images: ['/assets/iPhone-16-Pro/1.png', '/assets/iPhone-16-Pro/2.png', '/assets/iPhone-16-Pro/3.png', '/assets/iPhone-16-Pro/4.png'],
      variants: [
        {
          id: 'iphone-16-pro-256gb',
          name: '256GB',
          price: 999,
          color: 'Space Black',
        },
        {
          id: 'iphone-16-pro-512gb',
          name: '512GB',
          price: 1199,
          color: 'Titanium',
        }
      ]
    },
    {
      id: 'iphone-16e',
      name: 'iPhone 16e',
      type: 'iPhone',
      basePrice: 699,
      description: 'Affordable iPhone with essential features.',
      fullDescription: 'iPhone 16e brings the essential iPhone experience at an affordable price. Featuring a 6.1-inch Liquid Retina display, the powerful A16 Bionic chip, and a dual-camera system with 12MP main and Ultra Wide cameras. The aluminum and glass design is both beautiful and durable, while the all-day battery life keeps you connected. With 5G connectivity and the latest iOS features, iPhone 16e delivers the core iPhone experience at an incredible value.',
      rating: 4.6,
      isNew: true,
      mainImage: '/assets/iPhone-16e/1.png',
      images: ['/assets/iPhone-16e/1.png', '/assets/iPhone-16e/2.png', '/assets/iPhone-16e/3.png', '/assets/iPhone-16e/4.png'],
      variants: [
        {
          id: 'iphone-16e-64gb',
          name: '64GB',
          price: 699,
          color: 'Red',
        },
        {
          id: 'iphone-16e-128gb',
          name: '128GB',
          price: 799,
          color: 'White',
        }
      ]
    },
    {
      id: 'macbook-air',
      name: 'MacBook Air',
      type: 'MacBook',
      basePrice: 999,
      description: 'Incredibly thin and light with the power of M2 chip.',
      fullDescription: 'MacBook Air with M2 chip is a perfect balance of power and portability. The 13.6-inch Liquid Retina display delivers stunning visuals, while the M2 chip provides incredible performance and efficiency. With up to 18 hours of battery life, a fanless design, and a stunning thin and light aluminum enclosure, MacBook Air is the perfect laptop for everyday tasks. The Magic Keyboard with Touch ID, Force Touch trackpad, and Thunderbolt ports make it a joy to use.',
      rating: 4.7,
      isNew: false,
      mainImage: '/assets/MacBook-Air/1.png',
      images: ['/assets/MacBook-Air/1.png', '/assets/MacBook-Air/2.png', '/assets/MacBook-Air/3.png', '/assets/MacBook-Air/4.png'],
      variants: [
        {
          id: 'macbook-air-13',
          name: '13-inch',
          price: 999,
          color: 'Space Gray',
        },
        {
          id: 'macbook-air-15',
          name: '15-inch',
          price: 1299,
          color: 'Silver',
        }
      ]
    },
    {
      id: 'macbook-pro',
      name: 'MacBook Pro',
      type: 'MacBook',
      basePrice: 1999,
      description: 'The most powerful MacBook with M3 Pro or M3 Max chip.',
      fullDescription: 'MacBook Pro with M3 Pro or M3 Max chip redefines what a pro laptop can do. The stunning 16-inch Liquid Retina XDR display with ProMotion delivers incredible detail and color accuracy. The M3 Pro or M3 Max chip provides unprecedented performance for professional workflows, while the advanced thermal system keeps everything running smoothly. With up to 22 hours of battery life, a built-in SDXC card slot, HDMI port, and three Thunderbolt 4 ports, MacBook Pro is the ultimate tool for creative professionals.',
      rating: 4.9,
      isNew: true,
      mainImage: '/assets/MacBook-Pro/1.png',
      images: ['/assets/MacBook-Pro/1.png', '/assets/MacBook-Pro/2.png', '/assets/MacBook-Pro/3.png', '/assets/MacBook-Pro/4.png'],
      variants: [
        {
          id: 'macbook-pro-14',
          name: '14-inch',
          price: 1999,
          color: 'Space Gray',
        },
        {
          id: 'macbook-pro-16',
          name: '16-inch',
          price: 2499,
          color: 'Silver',
        }
      ]
    },
    {
      id: 'ipad-pro',
      name: 'iPad Pro',
      type: 'iPad',
      basePrice: 799,
      description: 'Supercharged by M2, the ultimate iPad experience.',
      fullDescription: 'iPad Pro with M2 chip is the ultimate iPad experience. The stunning 12.9-inch Liquid Retina XDR display with ProMotion delivers incredible detail and color accuracy. The M2 chip provides desktop-class performance for demanding tasks, while the advanced camera system with LiDAR Scanner enables incredible AR experiences. With Apple Pencil hover, Magic Keyboard support, and Thunderbolt connectivity, iPad Pro is a powerful tool for creative professionals and power users.',
      rating: 4.8,
      isNew: false,
      mainImage: '/assets/iPad-Pro/1.png',
      images: ['/assets/iPad-Pro/1.png', '/assets/iPad-Pro/2.png', '/assets/iPad-Pro/3.png', '/assets/iPad-Pro/4.png'],
      variants: [
        {
          id: 'ipad-pro-11',
          name: '11-inch',
          price: 799,
          color: 'Space Gray',
        },
        {
          id: 'ipad-pro-13',
          name: '12.9-inch',
          price: 1099,
          color: 'Silver',
        }
      ]
    },
    {
      id: 'ipad-air',
      name: 'iPad Air',
      type: 'iPad',
      basePrice: 599,
      description: 'Powerful. Colorful. Wonderful.',
      fullDescription: 'iPad Air with M1 chip brings powerful performance in a thin and light design. The 10.9-inch Liquid Retina display delivers stunning visuals, while the M1 chip provides incredible performance for demanding tasks. Available in five beautiful colors, iPad Air features Touch ID in the top button, USB-C connectivity, and support for Apple Pencil and Magic Keyboard. With all-day battery life and advanced cameras, iPad Air is perfect for work, creativity, and entertainment.',
      rating: 4.7,
      isNew: true,
      mainImage: '/assets/iPad-Air/1.png',
      images: ['/assets/iPad-Air/1.png', '/assets/iPad-Air/2.png', '/assets/iPad-Air/3.png', '/assets/iPad-Air/4.png'],
      variants: [
        {
          id: 'ipad-air-10.9',
          name: '10.9-inch',
          price: 599,
          color: 'Space Gray',
        },
        {
          id: 'ipad-air-11',
          name: '11-inch',
          price: 699,
          color: 'Blue',
        }
      ]
    },
    {
      id: 'ipad-mini',
      name: 'iPad Mini',
      type: 'iPad',
      basePrice: 499,
      description: 'Small in size. Big on capability.',
      fullDescription: 'iPad Mini packs the power of iPad into a compact 8.3-inch design. The Liquid Retina display delivers stunning visuals, while the A15 Bionic chip provides incredible performance. With Touch ID in the top button, USB-C connectivity, and support for Apple Pencil, iPad Mini is perfect for on-the-go productivity and creativity. The advanced cameras and all-day battery life make it ideal for capturing and sharing moments wherever you are.',
      rating: 4.6,
      isNew: false,
      mainImage: '/assets/iPad-Mini/1.png',
      images: ['/assets/iPad-Mini/1.png', '/assets/iPad-Mini/2.png', '/assets/iPad-Mini/3.png', '/assets/iPad-Mini/4.png'],
      variants: [
        {
          id: 'ipad-mini-8.3',
          name: '8.3-inch',
          price: 499,
          color: 'Space Gray',
        },
        {
          id: 'ipad-mini-8.3-cellular',
          name: '8.3-inch Cellular',
          price: 649,
          color: 'Purple',
        }
      ]
    }
  ];

  private processProduct(product: Product): Product {
    return {
      ...product,
      mainImage: this.getFullImageUrl(product.mainImage),
      images: product.images.map(image => this.getFullImageUrl(image))
    };
  }

  public getAllProducts(): Product[] {
    return this.products.map(product => this.processProduct(product));
  }

  public getProductById(id: string): Product | undefined {
    const product = this.products.find(product => product.id === id);
    return product ? this.processProduct(product) : undefined;
  }

  public getProductList(): Array<{
    id: string;
    name: string;
    type: string;
    price: number;
    isNew: boolean;
    rating: number;
    description: string;
    mainImage: string;
  }> {
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

  public getProductDetails(id: string): Omit<Product, 'variants'> & { variants: Omit<ProductVariant, 'images'>[] } | undefined {
    const product = this.products.find(product => product.id === id);
    if (!product) return undefined;
    
    return {
      id: product.id,
      name: product.name,
      type: product.type,
      basePrice: product.basePrice,
      description: product.description,
      fullDescription: product.fullDescription,
      rating: product.rating,
      isNew: product.isNew,
      mainImage: this.getFullImageUrl(product.mainImage),
      images: product.images.map(image => this.getFullImageUrl(image)),
      variants: product.variants.map(variant => ({
        id: variant.id,
        name: variant.name,
        price: variant.price,
        color: variant.color
      }))
    };
  }
} 