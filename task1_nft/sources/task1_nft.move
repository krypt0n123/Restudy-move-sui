//packageid:0x2026cdb84736247f39cd6755ccfb9c3a10d786888afe65097b8bd576d181dd3b
//tx:GBuJhHpcgM7oQYbowV2mwyiQuPseEoJeSFiDsNShGo5Q
module task1_nft::task1_nft {
    use std::string::{Self, String};
    use sui::package;
    use sui::display;

    public struct MyNFT has key, store {
        id: UID,
        name: String,
        image_url: String,
        creator: address,
    }

    public struct TASK1_NFT has drop {}

    fun init(otw: TASK1_NFT, ctx: &mut TxContext) {
        let publisher = package::claim(otw, ctx);

        let keys = vector[
            string::utf8(b"name"),
            string::utf8(b"image_url"),
            string::utf8(b"creator")
        ];
        let values = vector[
            string::utf8(b"{name}"),
            string::utf8(b"{image_url}"),
            string::utf8(b"@{creator}")
        ];
        let mut display = display::new_with_fields<MyNFT>(
            &publisher, keys, values, ctx
        );

        display::update_version(&mut display);

        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(display, tx_context::sender(ctx));
    }

    public entry fun mint(ctx: &mut TxContext) {
        let nft = MyNFT {
            id: object::new(ctx),
            name: string::utf8(b"krypton"),
            image_url: string::utf8(b"https://salmon-real-slug-885.mypinata.cloud/ipfs/bafkreicsqvikrsp5ytm3pajjpguebjwmypcr7i7f32a5gs6cedrjv7bfi4"),
            creator: tx_context::sender(ctx),
        };
        transfer::transfer(nft, tx_context::sender(ctx));
    }

    public entry fun transfer_nft(_nft: MyNFT, to_address: address, ctx: &mut TxContext){
        assert!(_nft.creator == tx_context::sender(ctx));
        transfer::transfer(_nft, to_address);
    }

    public fun burn(_nft: MyNFT, _: &mut TxContext){
        let MyNFT { id, name: _, image_url: _, creator: _ } = _nft;
        object::delete(id);
    }
}