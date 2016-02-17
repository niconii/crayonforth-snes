use std::io::prelude::*;
use std::fs::File;

fn main() {
    let filename = std::env::args().nth(1).expect("No filename given");

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

        /*
        for (i, &byte) in data.iter().enumerate() {
            print!("{}", byte);
            if i % width == width-1 { println!(""); }
        }

        println!("Palette:");
        */

        if iter.next() != Some(0x0c) {
            panic!("Wrong palette marker byte");
        }
    }

    let mut palette = vec![];

    f.read_to_end(&mut palette).expect("Failed to read palette");

    /*
    for (i, triple) in palette.chunks(3).enumerate() {
        println!("{:>3}: #{:02x}{:02x}{:02x}", i, triple[0], triple[1], triple[2]);
    }
    */

    let mut output = vec![];

    for y in 0..(height/8) {
        for x in 0..(width/8) {
            for ty in 0..8 {
                let mut row0 = 0u8;
                let mut row1 = 0u8;

                for tx in 0..8 {
                    let pixel = data[(y*8 + ty)*width + x*8 + tx];
                    row0 |= (pixel & 1) << (7-tx);
                    row1 |= ((pixel & 2) >> 1) << (7-tx);
                }

                output.push(row0);
                output.push(row1);
            }
        }
    }

    let mut out = File::create(format!("{}.til", filename)).expect("Failed to create output file");

    out.write_all(&output).expect("Failed to write output");
}
