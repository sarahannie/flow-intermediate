import FungibleToken from 0x05
import SarahToken from 0x05

transaction(receiver: Address, amount: UFix64) {

    prepare(signer: AuthAccount) {
        // Borrow the SarahToken Minter reference
        let minter = signer.borrow<&SarahToken.Minter>(from: /storage/MinterStorage)
            ?? panic("You are not the SarahToken minter")
        
        // Borrow the receiver's SarahToken Vault capability
        let receiverVault = getAccount(receiver)
            .getCapability<&SarahToken.Vault{FungibleToken.Receiver}>(/public/Vault)
            .borrow()
            ?? panic("Error: Check your SarahToken Vault status")
        
        // Minted tokens reference
        let mintedTokens <- minter.mintToken(amount: amount)

        // Deposit minted tokens into the receiver's SarahToken Vault
        receiverVault.deposit(from: <-mintedTokens)
    }

    execute {
        log("Minted and deposited Uhanmi tokens successfully")
        log(amount.toString().concat(" Tokens minted and deposited"))
    }
}
