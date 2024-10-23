use ic_cdk::export::candid::{CandidType, Deserialize};
use ic_cdk_macros::{query, update};
use reqwest;
use serde::Deserialize;
use std::collections::HashMap;

#[derive(CandidType, Deserialize, Clone)]
struct PriceData {
    price: f64,
}

#[update]
async fn find_best_price(token_a: String, token_b: String) -> f64 {
    let price1 = get_price_from_amm1(&token_a, &token_b).await;
    let price2 = get_price_from_amm2(&token_a, &token_b).await;

    if price1 > price2 {
        price1
    } else {
        price2
    }
}

async fn get_price_from_amm1(token_a: &str, token_b: &str) -> f64 {
    let url = format!(
        "https://api.uniswap.org/v1/prices?pair={}-{}",
        token_a, token_b
    );
    let response = reqwest::get(&url).await.unwrap();
    let price_data: PriceData = response.json().await.unwrap();
    price_data.price
}

async fn get_price_from_amm2(token_a: &str, token_b: &str) -> f64 {
    let url = format!(
        "https://api.sushi.com/v1/prices?pair={}-{}",
        token_a, token_b
    );
    let response = reqwest::get(&url).await.unwrap();
    let price_data: PriceData = response.json().await.unwrap();
    price_data.price
}

#[query]
fn greet() -> String {
    format!("Welcome to AMM Aggregator!")
}
