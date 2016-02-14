use std::io::prelude::*;
use std::fs::OpenOptions;
use std::io::SeekFrom;

fn main() {
    let filename = std::env::args().nth(1).expect("No filename given");

    let mut f = OpenOptions::new()
        .read(true).write(true).append(false).truncate(false)
        .open(filename).expect("Failed to open file");

    f.seek(SeekFrom::Start(0x007fdc)).expect("File too short");

    f.write(&[0xff, 0xff, 0x00, 0x00]).expect("Couldn't write to file");

    f.seek(SeekFrom::Start(0x000000)).expect("Couldn't seek to beginning");

    let mut checksum = 0x0000u16;
    for byte in (&f).bytes().map(|b| b.expect("Couldn't read file")) {
        checksum = checksum.wrapping_add(byte as u16);
    }

    f.seek(SeekFrom::Start(0x007fdc)).expect("File became too short");

    let hi = ((checksum & 0xff00) >> 8) as u8;
    let lo = (checksum & 0x00ff) as u8;

    f.write(&[!lo, !hi, lo, hi]).expect("Couldn't write to file");
}
