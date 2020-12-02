use std::fs::File;
use std::io::{self, prelude::*, BufReader};
use std::str::Chars;

fn main() -> io::Result<()> {
    #[derive(Clone, Copy, Debug)]
    enum State {
        LOWER,
        UPPER,
        CHAR,
        PASSWORD,
    }

    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let mut num_valid_part_1 = 0;
    let mut num_valid_part_2 = 0;

    for line in reader.lines() {
        let l = line?;
        let chars: Chars = l.chars();

        let mut lower_bound: u32 = 0;
        let mut upper_bound: u32 = 0;
        let mut validation_char: char = '-';
        let password: &str;

        let mut state = State::LOWER;
        let mut buffer: String = String::new();
        for c in chars {
            match c {
                ' ' => match state {
                    State::UPPER => {
                        state = State::CHAR;
                        upper_bound = buffer.parse::<u32>().unwrap();
                        buffer = String::new();
                    }
                    State::CHAR => {
                        state = State::PASSWORD;
                        validation_char = buffer.chars().nth(0).unwrap();
                        buffer = String::new();
                    }
                    _ => {}
                },
                '-' => match state {
                    State::LOWER => {
                        state = State::UPPER;
                        lower_bound = buffer.parse::<u32>().unwrap();
                        buffer = String::new();
                    }
                    _ => {}
                },
                ':' => {}
                _ => buffer = buffer + &c.to_string(),
            };
        }
        password = &buffer;

        let mut num_char_in_string = 0;
        for l in password.chars() {
            if l == validation_char {
                num_char_in_string += 1
            }
        }

        let is_valid_part_1 =
            num_char_in_string >= lower_bound && num_char_in_string <= upper_bound;

        if is_valid_part_1 {
            num_valid_part_1 += 1
        };

        let is_valid_part_2 = (password.chars().nth(lower_bound as usize - 1).unwrap()
            == validation_char)
            ^ (password.chars().nth(upper_bound as usize - 1).unwrap() == validation_char);

        if is_valid_part_2 {
            num_valid_part_2 += 1
        };

        // println!("{} {} {} {}, {}, {}, {}", lower_bound, upper_bound, validation_char, password, num_char_in_string, is_valid_part_1, is_valid_part_2);
    }

    println!("{} are valid for part 1.", num_valid_part_1);
    println!("{} are valid for part 2.", num_valid_part_2);

    Ok(())
}
