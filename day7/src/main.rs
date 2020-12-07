use std::fs::File;
use std::io::{self, BufReader, prelude::*};
use std::str::Chars;

#[derive(Clone, Debug, PartialEq)]
struct ContainedRule {
    contained_colour: String,
    contained_count: u8,
}

#[derive(Clone, Debug, PartialEq)]
struct ContainerRule {
    container_colour: String,
    contained_colours: Vec<ContainedRule>,
}

fn contains(colour: &str, rules: &Vec<ContainerRule>) -> Vec<String> {
    let mut containing: Vec<String> = Vec::new();
    for r in rules.to_vec().into_iter() {
        r.contained_colours.to_vec().iter()
            .filter(|t| t.contained_colour.eq(colour))
            .filter(|t| (t.contained_count) as i32 > 0)
            .for_each(|_| containing.push(r.container_colour.to_string()));
    }
    return containing;
}

fn number_inside(colour: &str, rules: &Vec<ContainerRule>) -> u32 {
    let found: &Option<ContainerRule> = &rules.to_vec().into_iter()
        .filter(|r| r.container_colour.eq(colour))
        .next();
    if found.is_none() {
        return 0;
    }
    if (found.as_ref().unwrap()).contained_colours.len() == 0 {
        return 1;
    }

    let mut inside: u32 = 1;
    for child in (&found.as_ref().unwrap()).contained_colours.to_vec().iter() {
        inside += child.contained_count as u32 * number_inside(&child.contained_colour, &rules);
    }
    return inside;
}

fn find_all_containing(colour: &str, rules: &Vec<ContainerRule>) -> Vec<String> {
    let mut containing: Vec<String> = contains(colour, rules);
    let mut incoming: Vec<String> = Vec::new();
    containing.dedup();
    let mut orig_size: usize = containing.len();
    loop {
        for col in containing.to_vec().iter() {
            incoming = contains(col.as_str(), rules);
            containing = [&containing[..], &incoming[..]].concat();
        }
        containing.sort();
        containing.dedup();

        if containing.len() == orig_size {
            return containing;
        }
        orig_size = containing.len();
    };
}

fn main() -> io::Result<()> {
    #[derive(Clone, Copy, Debug, PartialEq)]
    enum TokenType {
        COLOUR,
        NUMBER,
        CONTAINS,
        BAG,
        SEPARATOR,
        TERMINAL,
    }

    struct Token {
        value: String,
        token_type: TokenType,
    }

    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);

    let mut container_rules: Vec<ContainerRule> = Vec::new();

    for line in reader.lines() {
        let l = line?;
        let chars: Chars = l.chars();

        let mut tokens: Vec<Token> = Vec::new();
        let mut buffer: String = String::new();
        for c in chars {
            match c {
                ' ' => {
                    let token;
                    match buffer.as_str() {
                        "bag" | "bags" => {
                            token = Token { value: buffer.to_string(), token_type: TokenType::BAG };
                        }
                        "contain" => {
                            token = Token { value: buffer.to_string(), token_type: TokenType::CONTAINS };
                        }
                        "no" => {
                            tokens.push(Token { value: "0".to_string(), token_type: TokenType::NUMBER });
                            tokens.push(Token { value: "NONE".to_string(), token_type: TokenType::COLOUR });
                            tokens.push(Token { value: ".".to_string(), token_type: TokenType::TERMINAL });
                            break;
                        }
                        _ => {
                            let num = buffer.parse::<u8>();
                            match num {
                                Ok(_) => token = Token { value: buffer.to_string(), token_type: TokenType::NUMBER },
                                Err(_) => token = Token { value: buffer.to_string(), token_type: TokenType::COLOUR },
                            }
                        }
                    }
                    tokens.push(token);
                    buffer = String::new();
                }
                ',' => {
                    let token = Token { value: buffer.to_string(), token_type: TokenType::SEPARATOR };
                    tokens.push(token);
                    buffer = String::new();
                }
                '.' => {
                    let token = Token { value: buffer.to_string(), token_type: TokenType::TERMINAL };
                    tokens.push(token);
                    buffer = String::new();
                }
                _ => buffer = buffer + &c.to_string(),
            };
        }


        let mut container_colour: String = String::new();
        let mut contained_colour: String = String::new();
        let mut contained_rules: Vec<ContainedRule> = Vec::new();
        let mut count: u8 = 0;

        for mut i in 1..tokens.len() {
            let token: &Token = tokens.get(i).unwrap();
            let last = tokens.get(i - 1).unwrap();
            let next = tokens.get(i + 1);

            match token.token_type {
                TokenType::COLOUR => {
                    if last.token_type == TokenType::COLOUR {
                        if next.is_some() && next.unwrap().token_type == TokenType::BAG {
                            container_colour.push_str(&last.value.to_owned());
                            container_colour.push_str(" ");
                            container_colour.push_str(&token.value.to_owned());
                        }
                        if next.is_some() && (next.unwrap().token_type == TokenType::SEPARATOR || next.unwrap().token_type == TokenType::TERMINAL) {
                            contained_colour.push_str(&last.value.to_owned());
                            contained_colour.push_str(" ");
                            contained_colour.push_str(&token.value.to_owned());
                        }
                    }
                }
                TokenType::NUMBER => {
                    count = token.value.parse::<u8>().unwrap();
                }
                TokenType::SEPARATOR => {
                    contained_rules.push(ContainedRule {
                        contained_colour: contained_colour.to_owned(),
                        contained_count: count,
                    });
                    count = 0;
                    contained_colour = String::new();
                    i = i + 1;
                }
                TokenType::TERMINAL => {
                    contained_rules.push(ContainedRule {
                        contained_colour: contained_colour.to_owned(),
                        contained_count: count,
                    });
                    count = 0;
                    contained_colour = String::new();
                    container_rules.push(ContainerRule {
                        container_colour: container_colour.to_owned(),
                        contained_colours: contained_rules.to_vec(),
                    });
                    contained_rules = Vec::new();
                    container_colour = String::new();
                }
                _ => {}
            }
        }
    }

    println!("Part 1:  {}.", find_all_containing("shiny gold", &container_rules).len());

    println!("Part 2:  {}.", number_inside("shiny gold", &container_rules) - 1);

    Ok(())
}