import Func "mo:base/Func";
import Hash "mo:base/Hash";
import Iter "mo:base/Iter";

import HashMap "mo:base/HashMap";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Array "mo:base/Array";
import Option "mo:base/Option";
import Result "mo:base/Result";
import Debug "mo:base/Debug";

actor {
  // Define the TaxPayer type
  type TaxPayer = {
    tid: Nat;
    firstName: Text;
    lastName: Text;
    address: Text;
  };

  // Create a stable variable to store TaxPayer records
  stable var taxPayerEntries : [(Nat, TaxPayer)] = [];
  var taxPayers = HashMap.HashMap<Nat, TaxPayer>(0, Nat.equal, Nat.hash);

  // Create a mutable variable to keep track of the next available TID
  stable var nextTID : Nat = 1;

  // Function to create a new TaxPayer record
  public func createTaxPayer(firstName: Text, lastName: Text, address: Text) : async Result.Result<Nat, Text> {
    let newTaxPayer : TaxPayer = {
      tid = nextTID;
      firstName = firstName;
      lastName = lastName;
      address = address;
    };
    taxPayers.put(nextTID, newTaxPayer);
    nextTID += 1;
    #ok(newTaxPayer.tid)
  };

  // Function to get all TaxPayer records
  public query func getAllTaxPayers() : async [TaxPayer] {
    Array.map<(Nat, TaxPayer), TaxPayer>(Iter.toArray(taxPayers.entries()), func (_, taxPayer) = taxPayer)
  };

  // Function to get a TaxPayer by TID
  public query func getTaxPayerByTID(tid: Nat) : async ?TaxPayer {
    taxPayers.get(tid)
  };

  // Function to update a TaxPayer record
  public func updateTaxPayer(tid: Nat, firstName: Text, lastName: Text, address: Text) : async Result.Result<(), Text> {
    switch (taxPayers.get(tid)) {
      case (null) {
        #err("TaxPayer not found")
      };
      case (?existingTaxPayer) {
        let updatedTaxPayer : TaxPayer = {
          tid = existingTaxPayer.tid;
          firstName = firstName;
          lastName = lastName;
          address = address;
        };
        taxPayers.put(tid, updatedTaxPayer);
        #ok()
      };
    }
  };

  // Function to delete a TaxPayer record
  public func deleteTaxPayer(tid: Nat) : async Result.Result<(), Text> {
    switch (taxPayers.remove(tid)) {
      case (null) {
        #err("TaxPayer not found")
      };
      case (?_) {
        #ok()
      };
    }
  };

  // System functions for upgrades
  system func preupgrade() {
    taxPayerEntries := Iter.toArray(taxPayers.entries());
  };

  system func postupgrade() {
    taxPayers := HashMap.fromIter<Nat, TaxPayer>(taxPayerEntries.vals(), 0, Nat.equal, Nat.hash);
    taxPayerEntries := [];
  };
}
