use std::io::prelude::*;
use std::fs::File;
use std::path::Path;

fn main() {
    let mut args = std::env::args();
    
    let _ = args.next();

    match &args.next().expect("No arguments given")[..] {
        "--1+1bpp" => {
            let a = args.next().expect("First input not given");
            let b = args.next().expect("Second input not given");
            let out = args.next().expect("Output not given");
            
            let mut a_img = Image::from_file(Path::new(&a));
            let b_img = Image::from_file(Path::new(&b));
            a_img.superimpose(&b_img, 1);
            
            a_img.to_2bpp(Path::new(&out));
        },
        "--2bpp" => {
            let a = args.next().expect("First input not given");
            let out = args.next().expect("Output not given");
            
            let a_img = Image::from_file(Path::new(&a));

            a_img.to_2bpp(Path::new(&out));
        },
        _ => panic!("No format given")
    }
}

struct Image {
    width: usize,
    height: usize,
    data: Vec<u8>,
    palette: Vec<u8>
}

impl Image {
    fn from_file(filename: &Path) -> Image {
        let mut f = File::open(&filename).expect("Failed to open file");

        let mut header = [0; 128];
        f.read_exact(&mut header).expect("Couldn't read header");

        let width = (((header[0x09] as u16) << 8) + (header[0x08] as u16) + 1) as usize;
        let height = (((header[0x0b] as u16) << 8) + (header[0x0a] as u16) + 1) as usize;

        let mut data = vec![];

        {
            let mut iter = (&f).bytes().map(|b| b.expect("Couldn't read file"));

            loop {
                match iter.next() {
                    None => break,
                    Some(n @ 0x00...0xbf) => data.push(n),
                    Some(times) => {
                        let n = iter.next().expect("Premature end of file");
                        for _ in 0..(times - 0xc0) {
                            data.push(n);
                        }
                    }
                }

                if data.len() >= width * height { break }
            }

            if iter.next() != Some(0x0c) {
                panic!("Wrong palette marker byte");
            }
        }

        let mut palette = vec![];

        f.read_to_end(&mut palette).expect("Failed to read palette");

        Image {
            width: width,
            height: height,
            data: data,
            palette: palette
        }
    }

    fn to_2bpp(&self, filename: &Path) {
        let mut output = vec![];

        for y in 0..(self.height/8) {
            for x in 0..(self.width/8) {
                for ty in 0..8 {
                    let mut row0 = 0u8;
                    let mut row1 = 0u8;

                    for tx in 0..8 {
                        let pixel = self.data[(y*8 + ty)*self.width + x*8 + tx];
                        row0 |= (pixel & 1) << (7-tx);
                        row1 |= ((pixel & 2) >> 1) << (7-tx);
                    }

                    output.push(row0);
                    output.push(row1);
                }
            }
        }

        let mut out = File::create(filename).expect("Failed to create output file");

        out.write_all(&output).expect("Failed to write output");
    }
    
    fn superimpose(&mut self, image: &Image, shift: usize) {
        assert_eq!(self.width, image.width);
        assert_eq!(self.height, image.height);

        for (i, byte) in self.data.iter_mut().enumerate() {
            *byte |= image.data[i] << shift;
        }
    }
}