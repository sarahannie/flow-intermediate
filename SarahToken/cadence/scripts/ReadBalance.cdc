import FungibleToken from 0x05
import SarahToken from 0x05

pub fun main(account: Address) {

    // Attempt to borrow PublicVault capability
    let publicVault: &SarahToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, SarahToken.CollectionPublic}? =
        getAccount(account).getCapability(/public/Vault)
            .borrow<&SarahToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, SarahToken.CollectionPublic}>()

    if (publicVault == nil) {
        // Create and link an empty vault if capability is not present
        let newVault <- SarahToken.createEmptyVault()
        getAuthAccount(account).save(<-newVault, to: /storage/VaultStorage)
        getAuthAccount(account).link<&SarahToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, SarahToken.CollectionPublic}>(
            /public/Vault,
            target: /storage/VaultStorage
        )
        log("Empty vault created")
        
        // Borrow the vault capability again to display its balance
        let retrievedVault: &SarahToken.Vault{FungibleToken.Balance}? =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&SarahToken.Vault{FungibleToken.Balance}>()
        log(retrievedVault?.balance)
    } else {        
        // Borrow the vault capability for further checks
        let checkVault: &SarahToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, SarahToken.CollectionPublic} =
            getAccount(account).getCapability(/public/Vault)
                .borrow<&SarahToken.Vault{FungibleToken.Balance, FungibleToken.Receiver, SarahToken.CollectionPublic}>()
                ?? panic("Vault capability not found")
        
        // Check if the vault's UUID is in the list of vaults
        if SarahToken.vaults.contains(checkVault.uuid) {
            log(publicVault?.balance)
            log("This is a SarahToken vault")
        } else {
            log("This is not a SarahToken vault")
        }
    }
}
