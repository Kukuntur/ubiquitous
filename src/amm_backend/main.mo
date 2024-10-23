import Debug "mo:base/Debug";
import Http "mo:base/Http";

actor AMMAggregator {

    public func findBestPrice(tokenA: Text, tokenB: Text) : async Float {
        Debug.print("Mencari harga terbaik untuk pertukaran " # tokenA # " ke " # tokenB);

        // Placeholder: Ambil harga dari berbagai AMM
        let price1 = await getPriceFromAMM1(tokenA, tokenB);
        let price2 = await getPriceFromAMM2(tokenA, tokenB);

        // Logika untuk menentukan harga terbaik
        if (price1 > price2) {
            return price1;
        } else {
            return price2;
        }
    };

    // Fungsi ini mengintegrasikan AMM1 (contoh Uniswap)
    private func getPriceFromAMM1(tokenA: Text, tokenB: Text) : async Float {
        let url = "https://api.uniswap.org/v1/prices?pair=" # tokenA # "-" # tokenB;
        let request = Http.Request(url, Http.Method.GET);
        let response = await Http.get(request);
        
        // Proses respons (deserialisasi JSON)
        return deserializePrice(response.body);
    };

    // Fungsi ini mengintegrasikan AMM2 (contoh SushiSwap)
    private func getPriceFromAMM2(tokenA: Text, tokenB: Text) : async Float {
        let url = "https://api.sushi.com/v1/prices?pair=" # tokenA # "-" # tokenB;
        let request = Http.Request(url, Http.Method.GET);
        let response = await Http.get(request);
        
        // Proses respons (deserialisasi JSON)
        return deserializePrice(response.body);
    };

    // Fungsi untuk mendeserialisasi data harga dari respons API
    private func deserializePrice(data: Blob) : Float {
        let priceText = Text.fromBlob(data);
        return Float.fromText(priceText);
    }
};
