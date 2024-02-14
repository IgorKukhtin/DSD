
{*********************************************************}
{                                                         }
{                    XML Data Binding                     }
{                                                         }
{         Generated on: 20.04.2023 00:03:44               }
{       Generated from: C:\Work\Temp\Диалог\ettn_v3.xml   }
{   Settings stored in: C:\Work\Temp\Диалог\ettn_v3.xdb   }
{                                                         }
{*********************************************************}

unit UAECMRXML;

interface

uses xmldom, XMLDoc, XMLIntf;

type

{ Forward Decls }

  IXMLUAECMRType = interface;
  IXMLECMRType = interface;
  IXMLExchangedDocumentContextType = interface;
  IXMLBusinessProcessSpecifiedDocumentContextParameterType = interface;
  IXMLGuidelineSpecifiedDocumentContextParameterType = interface;
  IXMLExchangedDocumentType = interface;
  IXMLIssueDateTimeType = interface;
  IXMLIncludedNoteType = interface;
  IXMLIncludedNoteTypeList = interface;
  IXMLContentCodeType = interface;
  IXMLIssueLogisticsLocationType = interface;
  IXMLSpecifiedSupplyChainConsignmentType = interface;
  IXMLGrossWeightMeasureType = interface;
  IXMLAssociatedInvoiceAmountType = interface;
  IXMLConsignorTradePartyType = interface;
  IXMLIDType = interface;
  IXMLPostalTradeAddressType = interface;
  IXMLConsigneeTradePartyType = interface;
  IXMLSpecifiedTaxRegistrationType = interface;
  IXMLSpecifiedGovernmentRegistrationType = interface;
  IXMLSpecifiedGovernmentRegistrationTypeList = interface;
  IXMLCarrierTradePartyType = interface;
  IXMLDefinedTradeContactType = interface;
  IXMLTelephoneUniversalCommunicationType = interface;
  IXMLEmailURIUniversalCommunicationType = interface;
  IXMLMobileTelephoneUniversalCommunicationType = interface;
  IXMLNotifiedTradePartyType = interface;
  IXMLCarrierAcceptanceLogisticsLocationType = interface;
  IXMLConsigneeReceiptLogisticsLocationType = interface;
  IXMLPhysicalGeographicalCoordinateType = interface;
  IXMLSystemIDType = interface;
  IXMLDeliveryTransportEventType = interface;
  IXMLActualOccurrenceDateTimeType = interface;
  IXMLScheduledOccurrenceDateTimeType = interface;
  IXMLCertifyingTradePartyType = interface;
  IXMLCertifyingTradePartyTypeList = interface;
  IXMLPickUpTransportEventType = interface;
  IXMLIncludedSupplyChainConsignmentItemType = interface;
  IXMLIncludedSupplyChainConsignmentItemTypeList = interface;
  IXMLInvoiceAmountType = interface;
  IXMLTariffQuantityType = interface;
  IXMLGlobalIDType = interface;
  IXMLNatureIdentificationTransportCargoType = interface;
  IXMLApplicableTransportDangerousGoodsType = interface;
  IXMLAssociatedReferencedLogisticsTransportEquipmentType = interface;
  IXMLTransportLogisticsPackageType = interface;
  IXMLPhysicalLogisticsShippingMarksType = interface;
  IXMLBarcodeLogisticsLabelType = interface;
  IXMLApplicableNoteType = interface;
  IXMLApplicableNoteTypeList = interface;
  IXMLUtilizedLogisticsTransportEquipmentType = interface;
  IXMLUtilizedLogisticsTransportEquipmentTypeList = interface;
  IXMLAffixedLogisticsSealType = interface;
  IXMLMainCarriageLogisticsTransportMovementType = interface;
  IXMLSpecifiedTransportEventType = interface;
  IXMLDeliveryInstructionsType = interface;

{ IXMLUAECMRType }

  IXMLUAECMRType = interface(IXMLNode)
    ['{AEFDF91A-FB30-4FBD-A650-0F8729F03C62}']
    { Property Accessors }
    function Get_ECMR: IXMLECMRType;
    { Methods & Properties }
    property ECMR: IXMLECMRType read Get_ECMR;
  end;

{ IXMLECMRType }

  IXMLECMRType = interface(IXMLNode)
    ['{FBF17EC7-AE01-4AD8-97E6-BC313E4DF17F}']
    { Property Accessors }
    function Get_ExchangedDocumentContext: IXMLExchangedDocumentContextType;
    function Get_ExchangedDocument: IXMLExchangedDocumentType;
    function Get_SpecifiedSupplyChainConsignment: IXMLSpecifiedSupplyChainConsignmentType;
    { Methods & Properties }
    property ExchangedDocumentContext: IXMLExchangedDocumentContextType read Get_ExchangedDocumentContext;
    property ExchangedDocument: IXMLExchangedDocumentType read Get_ExchangedDocument;
    property SpecifiedSupplyChainConsignment: IXMLSpecifiedSupplyChainConsignmentType read Get_SpecifiedSupplyChainConsignment;
  end;

{ IXMLExchangedDocumentContextType }

  IXMLExchangedDocumentContextType = interface(IXMLNode)
    ['{C58FEC8F-13EC-4CD1-891D-08E03D6EBDF9}']
    { Property Accessors }
    function Get_SpecifiedTransactionID: UnicodeString;
    function Get_BusinessProcessSpecifiedDocumentContextParameter: IXMLBusinessProcessSpecifiedDocumentContextParameterType;
    function Get_GuidelineSpecifiedDocumentContextParameter: IXMLGuidelineSpecifiedDocumentContextParameterType;
    procedure Set_SpecifiedTransactionID(Value: UnicodeString);
    { Methods & Properties }
    property SpecifiedTransactionID: UnicodeString read Get_SpecifiedTransactionID write Set_SpecifiedTransactionID;
    property BusinessProcessSpecifiedDocumentContextParameter: IXMLBusinessProcessSpecifiedDocumentContextParameterType read Get_BusinessProcessSpecifiedDocumentContextParameter;
    property GuidelineSpecifiedDocumentContextParameter: IXMLGuidelineSpecifiedDocumentContextParameterType read Get_GuidelineSpecifiedDocumentContextParameter;
  end;

{ IXMLBusinessProcessSpecifiedDocumentContextParameterType }

  IXMLBusinessProcessSpecifiedDocumentContextParameterType = interface(IXMLNode)
    ['{F842F224-5572-40B5-ADAF-B5ED7E26D780}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
  end;

{ IXMLGuidelineSpecifiedDocumentContextParameterType }

  IXMLGuidelineSpecifiedDocumentContextParameterType = interface(IXMLNode)
    ['{3D49E440-56B3-44AE-B003-55F4DA1513EF}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
  end;

{ IXMLExchangedDocumentType }

  IXMLExchangedDocumentType = interface(IXMLNode)
    ['{0EF26231-BFB5-408A-9E41-F9C57E136E44}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    function Get_IssueDateTime: IXMLIssueDateTimeType;
    function Get_IncludedNote: IXMLIncludedNoteTypeList;
    function Get_IssueLogisticsLocation: IXMLIssueLogisticsLocationType;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
    property IssueDateTime: IXMLIssueDateTimeType read Get_IssueDateTime;
    property IncludedNote: IXMLIncludedNoteTypeList read Get_IncludedNote;
    property IssueLogisticsLocation: IXMLIssueLogisticsLocationType read Get_IssueLogisticsLocation;
  end;

{ IXMLIssueDateTimeType }

  IXMLIssueDateTimeType = interface(IXMLNode)
    ['{5CFC1891-15AB-47CE-8861-9FC3CC42012D}']
    { Property Accessors }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
    { Methods & Properties }
    property DateTime: UnicodeString read Get_DateTime write Set_DateTime;
  end;

{ IXMLIncludedNoteType }

  IXMLIncludedNoteType = interface(IXMLNode)
    ['{D0C1E235-6D3D-4019-A456-4E5B0BCF3FE1}']
    { Property Accessors }
    function Get_ContentCode: IXMLContentCodeType;
    function Get_Content: UnicodeString;
    procedure Set_Content(Value: UnicodeString);
    { Methods & Properties }
    property ContentCode: IXMLContentCodeType read Get_ContentCode;
    property Content: UnicodeString read Get_Content write Set_Content;
  end;

{ IXMLIncludedNoteTypeList }

  IXMLIncludedNoteTypeList = interface(IXMLNodeCollection)
    ['{CB4533C2-2231-4115-9EB1-D432DE4424DA}']
    { Methods & Properties }
    function Add: IXMLIncludedNoteType;
    function Insert(const Index: Integer): IXMLIncludedNoteType;

    function Get_Item(Index: Integer): IXMLIncludedNoteType;
    property Items[Index: Integer]: IXMLIncludedNoteType read Get_Item; default;
  end;

{ IXMLContentCodeType }

  IXMLContentCodeType = interface(IXMLNode)
    ['{C2E8D595-1242-4C9C-ACC8-5B896A17C018}']
    { Property Accessors }
    function Get_ListAgencyID: UnicodeString;
    procedure Set_ListAgencyID(Value: UnicodeString);
    { Methods & Properties }
    property ListAgencyID: UnicodeString read Get_ListAgencyID write Set_ListAgencyID;
  end;

{ IXMLIssueLogisticsLocationType }

  IXMLIssueLogisticsLocationType = interface(IXMLNode)
    ['{8F95E894-C4B3-4AAA-A47D-8A261590F910}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property Description: UnicodeString read Get_Description write Set_Description;
  end;

{ IXMLSpecifiedSupplyChainConsignmentType }

  IXMLSpecifiedSupplyChainConsignmentType = interface(IXMLNode)
    ['{0D48483C-9518-47A6-B2FA-D59E22E72729}']
    { Property Accessors }
    function Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
    function Get_AssociatedInvoiceAmount: IXMLAssociatedInvoiceAmountType;
    function Get_ConsignmentItemQuantity: Double;
    function Get_ConsignorTradeParty: IXMLConsignorTradePartyType;
    function Get_ConsigneeTradeParty: IXMLConsigneeTradePartyType;
    function Get_CarrierTradeParty: IXMLCarrierTradePartyType;
    function Get_NotifiedTradeParty: IXMLNotifiedTradePartyType;
    function Get_CarrierAcceptanceLogisticsLocation: IXMLCarrierAcceptanceLogisticsLocationType;
    function Get_ConsigneeReceiptLogisticsLocation: IXMLConsigneeReceiptLogisticsLocationType;
    function Get_DeliveryTransportEvent: IXMLDeliveryTransportEventType;
    function Get_PickUpTransportEvent: IXMLPickUpTransportEventType;
    function Get_IncludedSupplyChainConsignmentItem: IXMLIncludedSupplyChainConsignmentItemTypeList;
    function Get_UtilizedLogisticsTransportEquipment: IXMLUtilizedLogisticsTransportEquipmentTypeList;
    function Get_MainCarriageLogisticsTransportMovement: IXMLMainCarriageLogisticsTransportMovementType;
    function Get_DeliveryInstructions: IXMLDeliveryInstructionsType;
    procedure Set_ConsignmentItemQuantity(Value: Double);
    { Methods & Properties }
    property GrossWeightMeasure: IXMLGrossWeightMeasureType read Get_GrossWeightMeasure;
    property AssociatedInvoiceAmount: IXMLAssociatedInvoiceAmountType read Get_AssociatedInvoiceAmount;
    property ConsignmentItemQuantity: Double read Get_ConsignmentItemQuantity write Set_ConsignmentItemQuantity;
    property ConsignorTradeParty: IXMLConsignorTradePartyType read Get_ConsignorTradeParty;
    property ConsigneeTradeParty: IXMLConsigneeTradePartyType read Get_ConsigneeTradeParty;
    property CarrierTradeParty: IXMLCarrierTradePartyType read Get_CarrierTradeParty;
    property NotifiedTradeParty: IXMLNotifiedTradePartyType read Get_NotifiedTradeParty;
    property CarrierAcceptanceLogisticsLocation: IXMLCarrierAcceptanceLogisticsLocationType read Get_CarrierAcceptanceLogisticsLocation;
    property ConsigneeReceiptLogisticsLocation: IXMLConsigneeReceiptLogisticsLocationType read Get_ConsigneeReceiptLogisticsLocation;
    property DeliveryTransportEvent: IXMLDeliveryTransportEventType read Get_DeliveryTransportEvent;
    property PickUpTransportEvent: IXMLPickUpTransportEventType read Get_PickUpTransportEvent;
    property IncludedSupplyChainConsignmentItem: IXMLIncludedSupplyChainConsignmentItemTypeList read Get_IncludedSupplyChainConsignmentItem;
    property UtilizedLogisticsTransportEquipment: IXMLUtilizedLogisticsTransportEquipmentTypeList read Get_UtilizedLogisticsTransportEquipment;
    property MainCarriageLogisticsTransportMovement: IXMLMainCarriageLogisticsTransportMovementType read Get_MainCarriageLogisticsTransportMovement;
    property DeliveryInstructions: IXMLDeliveryInstructionsType read Get_DeliveryInstructions;
  end;

{ IXMLGrossWeightMeasureType }

  IXMLGrossWeightMeasureType = interface(IXMLNode)
    ['{CB446382-EEE6-4F4F-8C34-893D5CB0978D}']
    { Property Accessors }
    function Get_UnitCode: UnicodeString;
    procedure Set_UnitCode(Value: UnicodeString);
    { Methods & Properties }
    property UnitCode: UnicodeString read Get_UnitCode write Set_UnitCode;
  end;

{ IXMLAssociatedInvoiceAmountType }

  IXMLAssociatedInvoiceAmountType = interface(IXMLNode)
    ['{3AF40B69-9A83-46B6-93DC-0ABB5C20D37F}']
    { Property Accessors }
    function Get_CurrencyID: UnicodeString;
    procedure Set_CurrencyID(Value: UnicodeString);
    { Methods & Properties }
    property CurrencyID: UnicodeString read Get_CurrencyID write Set_CurrencyID;
  end;

{ IXMLConsignorTradePartyType }

  IXMLConsignorTradePartyType = interface(IXMLNode)
    ['{F6128FD9-4A19-43BD-A4F1-6126BB703F6A}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property RoleCode: UnicodeString read Get_RoleCode write Set_RoleCode;
    property PostalTradeAddress: IXMLPostalTradeAddressType read Get_PostalTradeAddress;
    property DefinedTradeContact: IXMLDefinedTradeContactType read Get_DefinedTradeContact;
    property SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType read Get_SpecifiedGovernmentRegistration;
    property SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType read Get_SpecifiedTaxRegistration;
  end;

{ IXMLIDType }

  IXMLIDType = interface(IXMLNode)
    ['{4A865F0A-8E76-4EE6-923A-4DAF1777F957}']
    { Property Accessors }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
    { Methods & Properties }
    property SchemeAgencyID: UnicodeString read Get_SchemeAgencyID write Set_SchemeAgencyID;
  end;

{ IXMLPostalTradeAddressType }

  IXMLPostalTradeAddressType = interface(IXMLNode)
    ['{C0C679C2-85EE-4EE5-930A-4E7B5F3D4861}']
    { Property Accessors }
    function Get_PostcodeCode: UnicodeString;
    function Get_StreetName: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_CountryID: UnicodeString;
    function Get_CountrySubDivisionName: UnicodeString;
    procedure Set_PostcodeCode(Value: UnicodeString);
    procedure Set_StreetName(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_CountryID(Value: UnicodeString);
    procedure Set_CountrySubDivisionName(Value: UnicodeString);
    { Methods & Properties }
    property PostcodeCode: UnicodeString read Get_PostcodeCode write Set_PostcodeCode;
    property StreetName: UnicodeString read Get_StreetName write Set_StreetName;
    property CityName: UnicodeString read Get_CityName write Set_CityName;
    property CountryID: UnicodeString read Get_CountryID write Set_CountryID;
    property CountrySubDivisionName: UnicodeString read Get_CountrySubDivisionName write Set_CountrySubDivisionName;
  end;

{ IXMLConsigneeTradePartyType }

  IXMLConsigneeTradePartyType = interface(IXMLNode)
    ['{D9B794C8-FCF0-4549-93E7-1E5926F34FF6}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property RoleCode: UnicodeString read Get_RoleCode write Set_RoleCode;
    property PostalTradeAddress: IXMLPostalTradeAddressType read Get_PostalTradeAddress;
    property DefinedTradeContact: IXMLDefinedTradeContactType read Get_DefinedTradeContact;
    property SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType read Get_SpecifiedGovernmentRegistration;
    property SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType read Get_SpecifiedTaxRegistration;
  end;

{ IXMLSpecifiedTaxRegistrationType }

  IXMLSpecifiedTaxRegistrationType = interface(IXMLNode)
    ['{BF3FE8FC-0F8C-44D3-B417-6080F918DB7F}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
  end;

{ IXMLSpecifiedGovernmentRegistrationType }

  IXMLSpecifiedGovernmentRegistrationType = interface(IXMLNode)
    ['{BF3FE8FC-0F8C-44D3-B417-6080F918DB7F}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    function Get_TypeCode: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    procedure Set_TypeCode(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
    property TypeCode: UnicodeString read Get_TypeCode write Set_TypeCode;
  end;

{ IXMLSpecifiedGovernmentRegistrationTypeList }

  IXMLSpecifiedGovernmentRegistrationTypeList = interface(IXMLNodeCollection)
    ['{92E6E078-23DB-4348-BC77-5190062733A5}']
    { Methods & Properties }
    function Add: IXMLSpecifiedGovernmentRegistrationType;
    function Insert(const Index: Integer): IXMLSpecifiedGovernmentRegistrationType;

    function Get_Item(Index: Integer): IXMLSpecifiedGovernmentRegistrationType;
    property Items[Index: Integer]: IXMLSpecifiedGovernmentRegistrationType read Get_Item; default;
  end;

{ IXMLCarrierTradePartyType }

  IXMLCarrierTradePartyType = interface(IXMLNode)
    ['{D37FF24F-1E9E-4395-9BB8-F369B3F85F73}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationTypeList;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property RoleCode: UnicodeString read Get_RoleCode write Set_RoleCode;
    property DefinedTradeContact: IXMLDefinedTradeContactType read Get_DefinedTradeContact;
    property PostalTradeAddress: IXMLPostalTradeAddressType read Get_PostalTradeAddress;
    property SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType read Get_SpecifiedTaxRegistration;
    property SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationTypeList read Get_SpecifiedGovernmentRegistration;
  end;

{ IXMLDefinedTradeContactType }

  IXMLDefinedTradeContactType = interface(IXMLNode)
    ['{7BD83573-18D9-4FC5-8FAE-D7F464F6D9EF}']
    { Property Accessors }
    function Get_PersonName: UnicodeString;
    function Get_TelephoneUniversalCommunication: IXMLTelephoneUniversalCommunicationType;
    function Get_EmailURIUniversalCommunication: IXMLEmailURIUniversalCommunicationType;
    function Get_MobileTelephoneUniversalCommunication: IXMLMobileTelephoneUniversalCommunicationType;
    procedure Set_PersonName(Value: UnicodeString);
    { Methods & Properties }
    property PersonName: UnicodeString read Get_PersonName write Set_PersonName;
    property TelephoneUniversalCommunication: IXMLTelephoneUniversalCommunicationType read Get_TelephoneUniversalCommunication;
    property EmailURIUniversalCommunication: IXMLEmailURIUniversalCommunicationType read Get_EmailURIUniversalCommunication;
    property MobileTelephoneUniversalCommunication: IXMLMobileTelephoneUniversalCommunicationType read Get_MobileTelephoneUniversalCommunication;
  end;

{ IXMLTelephoneUniversalCommunicationType }

  IXMLTelephoneUniversalCommunicationType = interface(IXMLNode)
    ['{6D6CCBA5-9BA1-43C4-931F-8F545E739111}']
    { Property Accessors }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
    { Methods & Properties }
    property CompleteNumber: UnicodeString read Get_CompleteNumber write Set_CompleteNumber;
  end;

{ IXMLEmailURIUniversalCommunicationType }

  IXMLEmailURIUniversalCommunicationType = interface(IXMLNode)
    ['{A369C699-0088-484B-AEFE-A5D3BABE507C}']
    { Property Accessors }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
    { Methods & Properties }
    property CompleteNumber: UnicodeString read Get_CompleteNumber write Set_CompleteNumber;
  end;

{ IXMLMobileTelephoneUniversalCommunicationType }

  IXMLMobileTelephoneUniversalCommunicationType = interface(IXMLNode)
    ['{DC65C260-1334-4AB2-B042-2BE80C90D3A0}']
    { Property Accessors }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
    { Methods & Properties }
    property CompleteNumber: UnicodeString read Get_CompleteNumber write Set_CompleteNumber;
  end;

{ IXMLNotifiedTradePartyType }

  IXMLNotifiedTradePartyType = interface(IXMLNode)
    ['{952211AA-0711-4F31-AE54-365FB6B163DF}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property RoleCode: UnicodeString read Get_RoleCode write Set_RoleCode;
    property PostalTradeAddress: IXMLPostalTradeAddressType read Get_PostalTradeAddress;
    property DefinedTradeContact: IXMLDefinedTradeContactType read Get_DefinedTradeContact;
    property SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType read Get_SpecifiedTaxRegistration;
    property SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType read Get_SpecifiedGovernmentRegistration;
  end;

{ IXMLCarrierAcceptanceLogisticsLocationType }

  IXMLCarrierAcceptanceLogisticsLocationType = interface(IXMLNode)
    ['{D7D4904C-DDD6-4428-9FF0-847CE88CFB77}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property TypeCode: Integer read Get_TypeCode write Set_TypeCode;
    property Description: UnicodeString read Get_Description write Set_Description;
    property PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType read Get_PhysicalGeographicalCoordinate;
  end;

{ IXMLConsigneeReceiptLogisticsLocationType }

  IXMLConsigneeReceiptLogisticsLocationType = interface(IXMLNode)
    ['{0B981312-0223-4153-968D-812390D138D9}']
    { Property Accessors }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property ID: IXMLIDType read Get_ID;
    property Name: UnicodeString read Get_Name write Set_Name;
    property TypeCode: Integer read Get_TypeCode write Set_TypeCode;
    property Description: UnicodeString read Get_Description write Set_Description;
    property PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType read Get_PhysicalGeographicalCoordinate;
  end;

{ IXMLPhysicalGeographicalCoordinateType }

  IXMLPhysicalGeographicalCoordinateType = interface(IXMLNode)
    ['{AD3B425D-F3FF-4EF5-9A3E-93450BBAAC41}']
    { Property Accessors }
    function Get_LatitudeMeasure: UnicodeString;
    function Get_LongitudeMeasure: UnicodeString;
    function Get_SystemID: IXMLSystemIDType;
    procedure Set_LatitudeMeasure(Value: UnicodeString);
    procedure Set_LongitudeMeasure(Value: UnicodeString);
    { Methods & Properties }
    property LatitudeMeasure: UnicodeString read Get_LatitudeMeasure write Set_LatitudeMeasure;
    property LongitudeMeasure: UnicodeString read Get_LongitudeMeasure write Set_LongitudeMeasure;
    property SystemID: IXMLSystemIDType read Get_SystemID;
  end;

{ IXMLSystemIDType }

  IXMLSystemIDType = interface(IXMLNode)
    ['{12459108-EF85-4A49-AEB7-E3D8F016CC8B}']
    { Property Accessors }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
    { Methods & Properties }
    property SchemeAgencyID: UnicodeString read Get_SchemeAgencyID write Set_SchemeAgencyID;
  end;

{ IXMLDeliveryTransportEventType }

  IXMLDeliveryTransportEventType = interface(IXMLNode)
    ['{3A573F81-027B-4201-B01F-D0DC30ECA736}']
    { Property Accessors }
    function Get_Description: UnicodeString;
    function Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
    function Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Description: UnicodeString read Get_Description write Set_Description;
    property ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType read Get_ActualOccurrenceDateTime;
    property ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType read Get_ScheduledOccurrenceDateTime;
    property CertifyingTradeParty: IXMLCertifyingTradePartyTypeList read Get_CertifyingTradeParty;
  end;

{ IXMLActualOccurrenceDateTimeType }

  IXMLActualOccurrenceDateTimeType = interface(IXMLNode)
    ['{B21B1066-5FE9-4704-B974-AFA0AC3D0614}']
    { Property Accessors }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
    { Methods & Properties }
    property DateTime: UnicodeString read Get_DateTime write Set_DateTime;
  end;

{ IXMLScheduledOccurrenceDateTimeType }

  IXMLScheduledOccurrenceDateTimeType = interface(IXMLNode)
    ['{C831D30F-6A11-44CF-9643-3773A7FADB2D}']
    { Property Accessors }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
    { Methods & Properties }
    property DateTime: UnicodeString read Get_DateTime write Set_DateTime;
  end;

{ IXMLCertifyingTradePartyType }

  IXMLCertifyingTradePartyType = interface(IXMLNode)
    ['{3AEE2F5F-6BDE-49FD-B835-BE9535B0D687}']
    { Property Accessors }
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    function Get_ID: IXMLIDType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
    { Methods & Properties }
    property Name: UnicodeString read Get_Name write Set_Name;
    property RoleCode: UnicodeString read Get_RoleCode write Set_RoleCode;
    property DefinedTradeContact: IXMLDefinedTradeContactType read Get_DefinedTradeContact;
    property PostalTradeAddress: IXMLPostalTradeAddressType read Get_PostalTradeAddress;
    property SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType read Get_SpecifiedTaxRegistration;
    property SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType read Get_SpecifiedGovernmentRegistration;
    property ID: IXMLIDType read Get_ID;
  end;

{ IXMLCertifyingTradePartyTypeList }

  IXMLCertifyingTradePartyTypeList = interface(IXMLNodeCollection)
    ['{138E781F-7F71-4C91-A822-F214FE65D45A}']
    { Methods & Properties }
    function Add: IXMLCertifyingTradePartyType;
    function Insert(const Index: Integer): IXMLCertifyingTradePartyType;

    function Get_Item(Index: Integer): IXMLCertifyingTradePartyType;
    property Items[Index: Integer]: IXMLCertifyingTradePartyType read Get_Item; default;
  end;

{ IXMLPickUpTransportEventType }

  IXMLPickUpTransportEventType = interface(IXMLNode)
    ['{9CE5A625-88F7-4CD9-89D8-0FDB90B5FDC8}']
    { Property Accessors }
    function Get_Description: UnicodeString;
    function Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
    function Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property Description: UnicodeString read Get_Description write Set_Description;
    property ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType read Get_ActualOccurrenceDateTime;
    property ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType read Get_ScheduledOccurrenceDateTime;
    property CertifyingTradeParty: IXMLCertifyingTradePartyTypeList read Get_CertifyingTradeParty;
  end;

{ IXMLIncludedSupplyChainConsignmentItemType }

  IXMLIncludedSupplyChainConsignmentItemType = interface(IXMLNode)
    ['{59170A61-A25F-4238-BDD7-83268DDD3C7A}']
    { Property Accessors }
    function Get_SequenceNumeric: Integer;
    function Get_InvoiceAmount: IXMLInvoiceAmountType;
    function Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
    function Get_TariffQuantity: IXMLTariffQuantityType;
    function Get_GlobalID: IXMLGlobalIDType;
    function Get_NatureIdentificationTransportCargo: IXMLNatureIdentificationTransportCargoType;
    function Get_ApplicableTransportDangerousGoods: IXMLApplicableTransportDangerousGoodsType;
    function Get_AssociatedReferencedLogisticsTransportEquipment: IXMLAssociatedReferencedLogisticsTransportEquipmentType;
    function Get_TransportLogisticsPackage: IXMLTransportLogisticsPackageType;
    function Get_ApplicableNote: IXMLApplicableNoteTypeList;
    procedure Set_SequenceNumeric(Value: Integer);
    { Methods & Properties }
    property SequenceNumeric: Integer read Get_SequenceNumeric write Set_SequenceNumeric;
    property InvoiceAmount: IXMLInvoiceAmountType read Get_InvoiceAmount;
    property GrossWeightMeasure: IXMLGrossWeightMeasureType read Get_GrossWeightMeasure;
    property TariffQuantity: IXMLTariffQuantityType read Get_TariffQuantity;
    property GlobalID: IXMLGlobalIDType read Get_GlobalID;
    property NatureIdentificationTransportCargo: IXMLNatureIdentificationTransportCargoType read Get_NatureIdentificationTransportCargo;
    property ApplicableTransportDangerousGoods: IXMLApplicableTransportDangerousGoodsType read Get_ApplicableTransportDangerousGoods;
    property AssociatedReferencedLogisticsTransportEquipment: IXMLAssociatedReferencedLogisticsTransportEquipmentType read Get_AssociatedReferencedLogisticsTransportEquipment;
    property TransportLogisticsPackage: IXMLTransportLogisticsPackageType read Get_TransportLogisticsPackage;
    property ApplicableNote: IXMLApplicableNoteTypeList read Get_ApplicableNote;
  end;

{ IXMLIncludedSupplyChainConsignmentItemTypeList }

  IXMLIncludedSupplyChainConsignmentItemTypeList = interface(IXMLNodeCollection)
    ['{138E781F-7F71-4C91-A821-F214FE65D45A}']
    { Methods & Properties }
    function Add: IXMLIncludedSupplyChainConsignmentItemType;
    function Insert(const Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;

    function Get_Item(Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;
    property Items[Index: Integer]: IXMLIncludedSupplyChainConsignmentItemType read Get_Item; default;
  end;

{ IXMLInvoiceAmountType }

  IXMLInvoiceAmountType = interface(IXMLNode)
    ['{76FD3DE9-1E4D-4CBE-9363-307D120E9CFE}']
    { Property Accessors }
    function Get_CurrencyID: UnicodeString;
    procedure Set_CurrencyID(Value: UnicodeString);
    { Methods & Properties }
    property CurrencyID: UnicodeString read Get_CurrencyID write Set_CurrencyID;
  end;

{ IXMLTariffQuantityType }

  IXMLTariffQuantityType = interface(IXMLNode)
    ['{4E2ECD8D-BA33-4C43-ABAA-AA41A8EBBC97}']
    { Property Accessors }
    function Get_UnitCode: UnicodeString;
    procedure Set_UnitCode(Value: UnicodeString);
    { Methods & Properties }
    property UnitCode: UnicodeString read Get_UnitCode write Set_UnitCode;
  end;

{ IXMLGlobalIDType }

  IXMLGlobalIDType = interface(IXMLNode)
    ['{81639D57-2C39-4D8E-B6C2-2C1526158A05}']
    { Property Accessors }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
    { Methods & Properties }
    property SchemeAgencyID: UnicodeString read Get_SchemeAgencyID write Set_SchemeAgencyID;
  end;

{ IXMLNatureIdentificationTransportCargoType }

  IXMLNatureIdentificationTransportCargoType = interface(IXMLNode)
    ['{56ACEC39-9F7A-49D3-811D-4E7C509AF382}']
    { Property Accessors }
    function Get_Identification: UnicodeString;
    procedure Set_Identification(Value: UnicodeString);
    { Methods & Properties }
    property Identification: UnicodeString read Get_Identification write Set_Identification;
  end;

{ IXMLApplicableTransportDangerousGoodsType }

  IXMLApplicableTransportDangerousGoodsType = interface(IXMLNode)
    ['{A75EA06F-B3BC-45FF-A83C-B89860FE7DCD}']
    { Property Accessors }
    function Get_UNDGIdentificationCode: Integer;
    function Get_PackagingDangerLevelCode: Integer;
    procedure Set_UNDGIdentificationCode(Value: Integer);
    procedure Set_PackagingDangerLevelCode(Value: Integer);
    { Methods & Properties }
    property UNDGIdentificationCode: Integer read Get_UNDGIdentificationCode write Set_UNDGIdentificationCode;
    property PackagingDangerLevelCode: Integer read Get_PackagingDangerLevelCode write Set_PackagingDangerLevelCode;
  end;

{ IXMLAssociatedReferencedLogisticsTransportEquipmentType }

  IXMLAssociatedReferencedLogisticsTransportEquipmentType = interface(IXMLNode)
    ['{0280043B-2AE5-4BB1-8E71-66190071D0ED}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
  end;

{ IXMLTransportLogisticsPackageType }

  IXMLTransportLogisticsPackageType = interface(IXMLNode)
    ['{F4527417-16CC-4FEE-9684-A4D9E6420E7A}']
    { Property Accessors }
    function Get_ItemQuantity: Double;
    function Get_TypeCode: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_PhysicalLogisticsShippingMarks: IXMLPhysicalLogisticsShippingMarksType;
    procedure Set_ItemQuantity(Value: Double);
    procedure Set_TypeCode(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
    { Methods & Properties }
    property ItemQuantity: Double read Get_ItemQuantity write Set_ItemQuantity;
    property TypeCode: UnicodeString read Get_TypeCode write Set_TypeCode;
    property Type_: UnicodeString read Get_Type_ write Set_Type_;
    property PhysicalLogisticsShippingMarks: IXMLPhysicalLogisticsShippingMarksType read Get_PhysicalLogisticsShippingMarks;
  end;

{ IXMLPhysicalLogisticsShippingMarksType }

  IXMLPhysicalLogisticsShippingMarksType = interface(IXMLNode)
    ['{3D455202-DC8B-4983-8BBA-37C4179F1B67}']
    { Property Accessors }
    function Get_Marking: UnicodeString;
    function Get_BarcodeLogisticsLabel: IXMLBarcodeLogisticsLabelType;
    procedure Set_Marking(Value: UnicodeString);
    { Methods & Properties }
    property Marking: UnicodeString read Get_Marking write Set_Marking;
    property BarcodeLogisticsLabel: IXMLBarcodeLogisticsLabelType read Get_BarcodeLogisticsLabel;
  end;

{ IXMLBarcodeLogisticsLabelType }

  IXMLBarcodeLogisticsLabelType = interface(IXMLNode)
    ['{958F368B-72B9-4B78-8B0A-C41650BB9494}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
  end;

{ IXMLApplicableNoteType }

  IXMLApplicableNoteType = interface(IXMLNode)
    ['{81832F41-183D-4ADD-B05E-0594646532B0}']
    { Property Accessors }
    function Get_ContentCode: UnicodeString;
    function Get_Content: UnicodeString;
    procedure Set_ContentCode(Value: UnicodeString);
    procedure Set_Content(Value: UnicodeString);
    { Methods & Properties }
    property ContentCode: UnicodeString read Get_ContentCode write Set_ContentCode;
    property Content: UnicodeString read Get_Content write Set_Content;
  end;

{ IXMLApplicableNoteTypeList }

  IXMLApplicableNoteTypeList = interface(IXMLNodeCollection)
    ['{943098D9-DE8F-4631-B3D2-3805D0266888}']
    { Methods & Properties }
    function Add: IXMLApplicableNoteType;
    function Insert(const Index: Integer): IXMLApplicableNoteType;

    function Get_Item(Index: Integer): IXMLApplicableNoteType;
    property Items[Index: Integer]: IXMLApplicableNoteType read Get_Item; default;
  end;

{ IXMLUtilizedLogisticsTransportEquipmentType }

  IXMLUtilizedLogisticsTransportEquipmentType = interface(IXMLNode)
    ['{EAC38654-C4E3-4BD3-8540-56AEAF0F03D7}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    function Get_ApplicableNote: IXMLApplicableNoteTypeList;
    function Get_CategoryCode: UnicodeString;
    function Get_CharacteristicCode: Integer;
    function Get_AffixedLogisticsSeal: IXMLAffixedLogisticsSealType;
    procedure Set_ID(Value: UnicodeString);
    procedure Set_CategoryCode(Value: UnicodeString);
    procedure Set_CharacteristicCode(Value: Integer);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
    property ApplicableNote: IXMLApplicableNoteTypeList read Get_ApplicableNote;
    property CategoryCode: UnicodeString read Get_CategoryCode write Set_CategoryCode;
    property CharacteristicCode: Integer read Get_CharacteristicCode write Set_CharacteristicCode;
    property AffixedLogisticsSeal: IXMLAffixedLogisticsSealType read Get_AffixedLogisticsSeal;
  end;

{ IXMLUtilizedLogisticsTransportEquipmentTypeList }

  IXMLUtilizedLogisticsTransportEquipmentTypeList = interface(IXMLNodeCollection)
    ['{53534E3B-04DE-43A5-86FD-76CF1385AFED}']
    { Methods & Properties }
    function Add: IXMLUtilizedLogisticsTransportEquipmentType;
    function Insert(const Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;

    function Get_Item(Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;
    property Items[Index: Integer]: IXMLUtilizedLogisticsTransportEquipmentType read Get_Item; default;
  end;

{ IXMLAffixedLogisticsSealType }

  IXMLAffixedLogisticsSealType = interface(IXMLNode)
    ['{FB94B9C4-5EFA-4DAA-B9B1-C9DAAF7211CF}']
    { Property Accessors }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    { Methods & Properties }
    property ID: UnicodeString read Get_ID write Set_ID;
  end;

{ IXMLMainCarriageLogisticsTransportMovementType }

  IXMLMainCarriageLogisticsTransportMovementType = interface(IXMLNodeCollection)
    ['{430D355E-0503-4EF4-991B-D773B8C90B73}']
    { Property Accessors }
    function Get_SpecifiedTransportEvent(Index: Integer): IXMLSpecifiedTransportEventType;
    { Methods & Properties }
    function Add: IXMLSpecifiedTransportEventType;
    function Insert(const Index: Integer): IXMLSpecifiedTransportEventType;
    property SpecifiedTransportEvent[Index: Integer]: IXMLSpecifiedTransportEventType read Get_SpecifiedTransportEvent; default;
  end;

{ IXMLSpecifiedTransportEventType }

  IXMLSpecifiedTransportEventType = interface(IXMLNode)
    ['{FB47F668-B0B2-4A18-9A60-B20BA38F99DF}']
    { Property Accessors }
    function Get_ID: Integer;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyType;
    procedure Set_ID(Value: Integer);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
    { Methods & Properties }
    property ID: Integer read Get_ID write Set_ID;
    property TypeCode: Integer read Get_TypeCode write Set_TypeCode;
    property Description: UnicodeString read Get_Description write Set_Description;
    property CertifyingTradeParty: IXMLCertifyingTradePartyType read Get_CertifyingTradeParty;
  end;

{ IXMLDeliveryInstructionsType }

  IXMLDeliveryInstructionsType = interface(IXMLNode)
    ['{8F87F15A-A211-4B6A-AF22-AF5AEC5B65BA}']
    { Property Accessors }
    function Get_Description: UnicodeString;
    function Get_DescriptionCode: UnicodeString;
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DescriptionCode(Value: UnicodeString);
    { Methods & Properties }
    property Description: UnicodeString read Get_Description write Set_Description;
    property DescriptionCode: UnicodeString read Get_DescriptionCode write Set_DescriptionCode;
  end;

{ Forward Decls }

  TXMLUAECMRType = class;
  TXMLECMRType = class;
  TXMLExchangedDocumentContextType = class;
  TXMLBusinessProcessSpecifiedDocumentContextParameterType = class;
  TXMLGuidelineSpecifiedDocumentContextParameterType = class;
  TXMLExchangedDocumentType = class;
  TXMLIssueDateTimeType = class;
  TXMLIncludedNoteType = class;
  TXMLIncludedNoteTypeList = class;
  TXMLContentCodeType = class;
  TXMLIssueLogisticsLocationType = class;
  TXMLSpecifiedSupplyChainConsignmentType = class;
  TXMLGrossWeightMeasureType = class;
  TXMLAssociatedInvoiceAmountType = class;
  TXMLConsignorTradePartyType = class;
  TXMLIDType = class;
  TXMLPostalTradeAddressType = class;
  TXMLConsigneeTradePartyType = class;
  TXMLSpecifiedTaxRegistrationType = class;
  TXMLSpecifiedGovernmentRegistrationType = class;
  TXMLSpecifiedGovernmentRegistrationTypeList = class;
  TXMLCarrierTradePartyType = class;
  TXMLDefinedTradeContactType = class;
  TXMLTelephoneUniversalCommunicationType = class;
  TXMLEmailURIUniversalCommunicationType = class;
  TXMLMobileTelephoneUniversalCommunicationType = class;
  TXMLNotifiedTradePartyType = class;
  TXMLCarrierAcceptanceLogisticsLocationType = class;
  TXMLConsigneeReceiptLogisticsLocationType = class;
  TXMLPhysicalGeographicalCoordinateType = class;
  TXMLSystemIDType = class;
  TXMLDeliveryTransportEventType = class;
  TXMLActualOccurrenceDateTimeType = class;
  TXMLScheduledOccurrenceDateTimeType = class;
  TXMLCertifyingTradePartyType = class;
  TXMLCertifyingTradePartyTypeList = class;
  TXMLPickUpTransportEventType = class;
  TXMLIncludedSupplyChainConsignmentItemType = class;
  TXMLIncludedSupplyChainConsignmentItemTypeList = class;
  TXMLInvoiceAmountType = class;
  TXMLTariffQuantityType = class;
  TXMLGlobalIDType = class;
  TXMLNatureIdentificationTransportCargoType = class;
  TXMLApplicableTransportDangerousGoodsType = class;
  TXMLAssociatedReferencedLogisticsTransportEquipmentType = class;
  TXMLTransportLogisticsPackageType = class;
  TXMLPhysicalLogisticsShippingMarksType = class;
  TXMLBarcodeLogisticsLabelType = class;
  TXMLApplicableNoteType = class;
  TXMLApplicableNoteTypeList = class;
  TXMLUtilizedLogisticsTransportEquipmentType = class;
  TXMLUtilizedLogisticsTransportEquipmentTypeList = class;
  TXMLAffixedLogisticsSealType = class;
  TXMLMainCarriageLogisticsTransportMovementType = class;
  TXMLSpecifiedTransportEventType = class;
  TXMLDeliveryInstructionsType = class;

{ TXMLUAECMRType }

  TXMLUAECMRType = class(TXMLNode, IXMLUAECMRType)
  protected
    { IXMLUAECMRType }
    function Get_ECMR: IXMLECMRType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLECMRType }

  TXMLECMRType = class(TXMLNode, IXMLECMRType)
  protected
    { IXMLECMRType }
    function Get_ExchangedDocumentContext: IXMLExchangedDocumentContextType;
    function Get_ExchangedDocument: IXMLExchangedDocumentType;
    function Get_SpecifiedSupplyChainConsignment: IXMLSpecifiedSupplyChainConsignmentType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLExchangedDocumentContextType }

  TXMLExchangedDocumentContextType = class(TXMLNode, IXMLExchangedDocumentContextType)
  protected
    { IXMLExchangedDocumentContextType }
    function Get_SpecifiedTransactionID: UnicodeString;
    function Get_BusinessProcessSpecifiedDocumentContextParameter: IXMLBusinessProcessSpecifiedDocumentContextParameterType;
    function Get_GuidelineSpecifiedDocumentContextParameter: IXMLGuidelineSpecifiedDocumentContextParameterType;
    procedure Set_SpecifiedTransactionID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBusinessProcessSpecifiedDocumentContextParameterType }

  TXMLBusinessProcessSpecifiedDocumentContextParameterType = class(TXMLNode, IXMLBusinessProcessSpecifiedDocumentContextParameterType)
  protected
    { IXMLBusinessProcessSpecifiedDocumentContextParameterType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
  end;

{ TXMLGuidelineSpecifiedDocumentContextParameterType }

  TXMLGuidelineSpecifiedDocumentContextParameterType = class(TXMLNode, IXMLGuidelineSpecifiedDocumentContextParameterType)
  protected
    { IXMLGuidelineSpecifiedDocumentContextParameterType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
  end;

{ TXMLExchangedDocumentType }

  TXMLExchangedDocumentType = class(TXMLNode, IXMLExchangedDocumentType)
  private
    FIncludedNote: IXMLIncludedNoteTypeList;
  protected
    { IXMLExchangedDocumentType }
    function Get_ID: UnicodeString;
    function Get_IssueDateTime: IXMLIssueDateTimeType;
    function Get_IncludedNote: IXMLIncludedNoteTypeList;
    function Get_IssueLogisticsLocation: IXMLIssueLogisticsLocationType;
    procedure Set_ID(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIssueDateTimeType }

  TXMLIssueDateTimeType = class(TXMLNode, IXMLIssueDateTimeType)
  protected
    { IXMLIssueDateTimeType }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
  end;

{ TXMLIncludedNoteType }

  TXMLIncludedNoteType = class(TXMLNode, IXMLIncludedNoteType)
  protected
    { IXMLIncludedNoteType }
    function Get_ContentCode: IXMLContentCodeType;
    function Get_Content: UnicodeString;
    procedure Set_Content(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIncludedNoteTypeList }

  TXMLIncludedNoteTypeList = class(TXMLNodeCollection, IXMLIncludedNoteTypeList)
  protected
    { IXMLIncludedNoteTypeList }
    function Add: IXMLIncludedNoteType;
    function Insert(const Index: Integer): IXMLIncludedNoteType;

    function Get_Item(Index: Integer): IXMLIncludedNoteType;
  end;

{ TXMLContentCodeType }

  TXMLContentCodeType = class(TXMLNode, IXMLContentCodeType)
  protected
    { IXMLContentCodeType }
    function Get_ListAgencyID: UnicodeString;
    procedure Set_ListAgencyID(Value: UnicodeString);
  end;

{ TXMLIssueLogisticsLocationType }

  TXMLIssueLogisticsLocationType = class(TXMLNode, IXMLIssueLogisticsLocationType)
  protected
    { IXMLIssueLogisticsLocationType }
    function Get_Name: UnicodeString;
    function Get_Description: UnicodeString;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_Description(Value: UnicodeString);
  end;

{ TXMLSpecifiedSupplyChainConsignmentType }

  TXMLSpecifiedSupplyChainConsignmentType = class(TXMLNode, IXMLSpecifiedSupplyChainConsignmentType)
  private
    FIncludedSupplyChainConsignmentItem: IXMLIncludedSupplyChainConsignmentItemTypeList;
    FUtilizedLogisticsTransportEquipment: IXMLUtilizedLogisticsTransportEquipmentTypeList;
  protected
    { IXMLSpecifiedSupplyChainConsignmentType }
    function Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
    function Get_AssociatedInvoiceAmount: IXMLAssociatedInvoiceAmountType;
    function Get_ConsignmentItemQuantity: Double;
    function Get_ConsignorTradeParty: IXMLConsignorTradePartyType;
    function Get_ConsigneeTradeParty: IXMLConsigneeTradePartyType;
    function Get_CarrierTradeParty: IXMLCarrierTradePartyType;
    function Get_NotifiedTradeParty: IXMLNotifiedTradePartyType;
    function Get_CarrierAcceptanceLogisticsLocation: IXMLCarrierAcceptanceLogisticsLocationType;
    function Get_ConsigneeReceiptLogisticsLocation: IXMLConsigneeReceiptLogisticsLocationType;
    function Get_DeliveryTransportEvent: IXMLDeliveryTransportEventType;
    function Get_PickUpTransportEvent: IXMLPickUpTransportEventType;
    function Get_IncludedSupplyChainConsignmentItem: IXMLIncludedSupplyChainConsignmentItemTypeList;
    function Get_UtilizedLogisticsTransportEquipment: IXMLUtilizedLogisticsTransportEquipmentTypeList;
    function Get_MainCarriageLogisticsTransportMovement: IXMLMainCarriageLogisticsTransportMovementType;
    function Get_DeliveryInstructions: IXMLDeliveryInstructionsType;
    procedure Set_ConsignmentItemQuantity(Value: Double);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLGrossWeightMeasureType }

  TXMLGrossWeightMeasureType = class(TXMLNode, IXMLGrossWeightMeasureType)
  protected
    { IXMLGrossWeightMeasureType }
    function Get_UnitCode: UnicodeString;
    procedure Set_UnitCode(Value: UnicodeString);
  end;

{ TXMLAssociatedInvoiceAmountType }

  TXMLAssociatedInvoiceAmountType = class(TXMLNode, IXMLAssociatedInvoiceAmountType)
  protected
    { IXMLAssociatedInvoiceAmountType }
    function Get_CurrencyID: UnicodeString;
    procedure Set_CurrencyID(Value: UnicodeString);
  end;

{ TXMLConsignorTradePartyType }

  TXMLConsignorTradePartyType = class(TXMLNode, IXMLConsignorTradePartyType)
  protected
    { IXMLConsignorTradePartyType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIDType }

  TXMLIDType = class(TXMLNode, IXMLIDType)
  protected
    { IXMLIDType }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
  end;

{ TXMLPostalTradeAddressType }

  TXMLPostalTradeAddressType = class(TXMLNode, IXMLPostalTradeAddressType)
  protected
    { IXMLPostalTradeAddressType }
    function Get_PostcodeCode: UnicodeString;
    function Get_StreetName: UnicodeString;
    function Get_CityName: UnicodeString;
    function Get_CountryID: UnicodeString;
    function Get_CountrySubDivisionName: UnicodeString;
    procedure Set_PostcodeCode(Value: UnicodeString);
    procedure Set_StreetName(Value: UnicodeString);
    procedure Set_CityName(Value: UnicodeString);
    procedure Set_CountryID(Value: UnicodeString);
    procedure Set_CountrySubDivisionName(Value: UnicodeString);
  end;

{ TXMLConsigneeTradePartyType }

  TXMLConsigneeTradePartyType = class(TXMLNode, IXMLConsigneeTradePartyType)
  protected
    { IXMLConsigneeTradePartyType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSpecifiedTaxRegistrationType }

  TXMLSpecifiedTaxRegistrationType = class(TXMLNode, IXMLSpecifiedTaxRegistrationType)
  protected
    { IXMLSpecifiedTaxRegistrationType }
    function Get_ID: IXMLIDType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSpecifiedGovernmentRegistrationType }

  TXMLSpecifiedGovernmentRegistrationType = class(TXMLNode, IXMLSpecifiedGovernmentRegistrationType)
  protected
    { IXMLSpecifiedGovernmentRegistrationType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
    function Get_TypeCode: UnicodeString;
    procedure Set_TypeCode(Value: UnicodeString);
  end;

{ TXMLSpecifiedGovernmentRegistrationTypeList }

  TXMLSpecifiedGovernmentRegistrationTypeList = class(TXMLNodeCollection, IXMLSpecifiedGovernmentRegistrationTypeList)
  protected
    { IXMLSpecifiedGovernmentRegistrationTypeList }
    function Add: IXMLSpecifiedGovernmentRegistrationType;
    function Insert(const Index: Integer): IXMLSpecifiedGovernmentRegistrationType;

    function Get_Item(Index: Integer): IXMLSpecifiedGovernmentRegistrationType;
  end;

{ TXMLCarrierTradePartyType }

  TXMLCarrierTradePartyType = class(TXMLNode, IXMLCarrierTradePartyType)
  private
    FSpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationTypeList;
  protected
    { IXMLCarrierTradePartyType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationTypeList;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDefinedTradeContactType }

  TXMLDefinedTradeContactType = class(TXMLNode, IXMLDefinedTradeContactType)
  protected
    { IXMLDefinedTradeContactType }
    function Get_PersonName: UnicodeString;
    function Get_TelephoneUniversalCommunication: IXMLTelephoneUniversalCommunicationType;
    function Get_EmailURIUniversalCommunication: IXMLEmailURIUniversalCommunicationType;
    function Get_MobileTelephoneUniversalCommunication: IXMLMobileTelephoneUniversalCommunicationType;
    procedure Set_PersonName(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLTelephoneUniversalCommunicationType }

  TXMLTelephoneUniversalCommunicationType = class(TXMLNode, IXMLTelephoneUniversalCommunicationType)
  protected
    { IXMLTelephoneUniversalCommunicationType }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
  end;

{ TXMLEmailURIUniversalCommunicationType }

  TXMLEmailURIUniversalCommunicationType = class(TXMLNode, IXMLEmailURIUniversalCommunicationType)
  protected
    { IXMLEmailURIUniversalCommunicationType }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
  end;

{ TXMLMobileTelephoneUniversalCommunicationType }

  TXMLMobileTelephoneUniversalCommunicationType = class(TXMLNode, IXMLMobileTelephoneUniversalCommunicationType)
  protected
    { IXMLMobileTelephoneUniversalCommunicationType }
    function Get_CompleteNumber: UnicodeString;
    procedure Set_CompleteNumber(Value: UnicodeString);
  end;

{ TXMLNotifiedTradePartyType }

  TXMLNotifiedTradePartyType = class(TXMLNode, IXMLNotifiedTradePartyType)
  protected
    { IXMLNotifiedTradePartyType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLCarrierAcceptanceLogisticsLocationType }

  TXMLCarrierAcceptanceLogisticsLocationType = class(TXMLNode, IXMLCarrierAcceptanceLogisticsLocationType)
  protected
    { IXMLCarrierAcceptanceLogisticsLocationType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLConsigneeReceiptLogisticsLocationType }

  TXMLConsigneeReceiptLogisticsLocationType = class(TXMLNode, IXMLConsigneeReceiptLogisticsLocationType)
  protected
    { IXMLConsigneeReceiptLogisticsLocationType }
    function Get_ID: IXMLIDType;
    function Get_Name: UnicodeString;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPhysicalGeographicalCoordinateType }

  TXMLPhysicalGeographicalCoordinateType = class(TXMLNode, IXMLPhysicalGeographicalCoordinateType)
  protected
    { IXMLPhysicalGeographicalCoordinateType }
    function Get_LatitudeMeasure: UnicodeString;
    function Get_LongitudeMeasure: UnicodeString;
    function Get_SystemID: IXMLSystemIDType;
    procedure Set_LatitudeMeasure(Value: UnicodeString);
    procedure Set_LongitudeMeasure(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSystemIDType }

  TXMLSystemIDType = class(TXMLNode, IXMLSystemIDType)
  protected
    { IXMLSystemIDType }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
  end;

{ TXMLDeliveryTransportEventType }

  TXMLDeliveryTransportEventType = class(TXMLNode, IXMLDeliveryTransportEventType)
  private
    FCertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
  protected
    { IXMLDeliveryTransportEventType }
    function Get_Description: UnicodeString;
    function Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
    function Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLActualOccurrenceDateTimeType }

  TXMLActualOccurrenceDateTimeType = class(TXMLNode, IXMLActualOccurrenceDateTimeType)
  protected
    { IXMLActualOccurrenceDateTimeType }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
  end;

{ TXMLScheduledOccurrenceDateTimeType }

  TXMLScheduledOccurrenceDateTimeType = class(TXMLNode, IXMLScheduledOccurrenceDateTimeType)
  protected
    { IXMLScheduledOccurrenceDateTimeType }
    function Get_DateTime: UnicodeString;
    procedure Set_DateTime(Value: UnicodeString);
  end;

{ TXMLCertifyingTradePartyType }

  TXMLCertifyingTradePartyType = class(TXMLNode, IXMLCertifyingTradePartyType)
  protected
    { IXMLCertifyingTradePartyType }
    function Get_Name: UnicodeString;
    function Get_RoleCode: UnicodeString;
    function Get_DefinedTradeContact: IXMLDefinedTradeContactType;
    function Get_PostalTradeAddress: IXMLPostalTradeAddressType;
    function Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
    function Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
    function Get_ID: IXMLIDType;
    procedure Set_Name(Value: UnicodeString);
    procedure Set_RoleCode(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;


{ TXMLCertifyingTradePartyTypeList }

  TXMLCertifyingTradePartyTypeList = class(TXMLNodeCollection, IXMLCertifyingTradePartyTypeList)
  protected
    { IXMLCertifyingTradePartyTypeList }
    function Add: IXMLCertifyingTradePartyType;
    function Insert(const Index: Integer): IXMLCertifyingTradePartyType;

    function Get_Item(Index: Integer): IXMLCertifyingTradePartyType;
  end;

{ TXMLPickUpTransportEventType }

  TXMLPickUpTransportEventType = class(TXMLNode, IXMLPickUpTransportEventType)
  private
    FCertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
  protected
    { IXMLPickUpTransportEventType }
    function Get_Description: UnicodeString;
    function Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
    function Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIncludedSupplyChainConsignmentItemType }

  TXMLIncludedSupplyChainConsignmentItemType = class(TXMLNode, IXMLIncludedSupplyChainConsignmentItemType)
  private
    FApplicableNote: IXMLApplicableNoteTypeList;
  protected
    { IXMLIncludedSupplyChainConsignmentItemType }
    function Get_SequenceNumeric: Integer;
    function Get_InvoiceAmount: IXMLInvoiceAmountType;
    function Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
    function Get_TariffQuantity: IXMLTariffQuantityType;
    function Get_GlobalID: IXMLGlobalIDType;
    function Get_NatureIdentificationTransportCargo: IXMLNatureIdentificationTransportCargoType;
    function Get_ApplicableTransportDangerousGoods: IXMLApplicableTransportDangerousGoodsType;
    function Get_AssociatedReferencedLogisticsTransportEquipment: IXMLAssociatedReferencedLogisticsTransportEquipmentType;
    function Get_TransportLogisticsPackage: IXMLTransportLogisticsPackageType;
    function Get_ApplicableNote: IXMLApplicableNoteTypeList;
    procedure Set_SequenceNumeric(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLIncludedSupplyChainConsignmentItemTypeList }

  TXMLIncludedSupplyChainConsignmentItemTypeList = class(TXMLNodeCollection, IXMLIncludedSupplyChainConsignmentItemTypeList)
  protected
    { IXMLIncludedSupplyChainConsignmentItemTypeList }
    function Add: IXMLIncludedSupplyChainConsignmentItemType;
    function Insert(const Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;

    function Get_Item(Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;
  end;

{ TXMLInvoiceAmountType }

  TXMLInvoiceAmountType = class(TXMLNode, IXMLInvoiceAmountType)
  protected
    { IXMLInvoiceAmountType }
    function Get_CurrencyID: UnicodeString;
    procedure Set_CurrencyID(Value: UnicodeString);
  end;

{ TXMLTariffQuantityType }

  TXMLTariffQuantityType = class(TXMLNode, IXMLTariffQuantityType)
  protected
    { IXMLTariffQuantityType }
    function Get_UnitCode: UnicodeString;
    procedure Set_UnitCode(Value: UnicodeString);
  end;

{ TXMLGlobalIDType }

  TXMLGlobalIDType = class(TXMLNode, IXMLGlobalIDType)
  protected
    { IXMLGlobalIDType }
    function Get_SchemeAgencyID: UnicodeString;
    procedure Set_SchemeAgencyID(Value: UnicodeString);
  end;

{ TXMLNatureIdentificationTransportCargoType }

  TXMLNatureIdentificationTransportCargoType = class(TXMLNode, IXMLNatureIdentificationTransportCargoType)
  protected
    { IXMLNatureIdentificationTransportCargoType }
    function Get_Identification: UnicodeString;
    procedure Set_Identification(Value: UnicodeString);
  end;

{ TXMLApplicableTransportDangerousGoodsType }

  TXMLApplicableTransportDangerousGoodsType = class(TXMLNode, IXMLApplicableTransportDangerousGoodsType)
  protected
    { IXMLApplicableTransportDangerousGoodsType }
    function Get_UNDGIdentificationCode: Integer;
    function Get_PackagingDangerLevelCode: Integer;
    procedure Set_UNDGIdentificationCode(Value: Integer);
    procedure Set_PackagingDangerLevelCode(Value: Integer);
  end;

{ TXMLAssociatedReferencedLogisticsTransportEquipmentType }

  TXMLAssociatedReferencedLogisticsTransportEquipmentType = class(TXMLNode, IXMLAssociatedReferencedLogisticsTransportEquipmentType)
  protected
    { IXMLAssociatedReferencedLogisticsTransportEquipmentType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
  end;

{ TXMLTransportLogisticsPackageType }

  TXMLTransportLogisticsPackageType = class(TXMLNode, IXMLTransportLogisticsPackageType)
  protected
    { IXMLTransportLogisticsPackageType }
    function Get_ItemQuantity: Double;
    function Get_TypeCode: UnicodeString;
    function Get_Type_: UnicodeString;
    function Get_PhysicalLogisticsShippingMarks: IXMLPhysicalLogisticsShippingMarksType;
    procedure Set_ItemQuantity(Value: Double);
    procedure Set_TypeCode(Value: UnicodeString);
    procedure Set_Type_(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLPhysicalLogisticsShippingMarksType }

  TXMLPhysicalLogisticsShippingMarksType = class(TXMLNode, IXMLPhysicalLogisticsShippingMarksType)
  protected
    { IXMLPhysicalLogisticsShippingMarksType }
    function Get_Marking: UnicodeString;
    function Get_BarcodeLogisticsLabel: IXMLBarcodeLogisticsLabelType;
    procedure Set_Marking(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLBarcodeLogisticsLabelType }

  TXMLBarcodeLogisticsLabelType = class(TXMLNode, IXMLBarcodeLogisticsLabelType)
  protected
    { IXMLBarcodeLogisticsLabelType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
  end;

{ TXMLApplicableNoteType }

  TXMLApplicableNoteType = class(TXMLNode, IXMLApplicableNoteType)
  protected
    { IXMLApplicableNoteType }
    function Get_ContentCode: UnicodeString;
    function Get_Content: UnicodeString;
    procedure Set_ContentCode(Value: UnicodeString);
    procedure Set_Content(Value: UnicodeString);
  end;

{ TXMLApplicableNoteTypeList }

  TXMLApplicableNoteTypeList = class(TXMLNodeCollection, IXMLApplicableNoteTypeList)
  protected
    { IXMLApplicableNoteTypeList }
    function Add: IXMLApplicableNoteType;
    function Insert(const Index: Integer): IXMLApplicableNoteType;

    function Get_Item(Index: Integer): IXMLApplicableNoteType;
  end;

{ TXMLUtilizedLogisticsTransportEquipmentType }

  TXMLUtilizedLogisticsTransportEquipmentType = class(TXMLNode, IXMLUtilizedLogisticsTransportEquipmentType)
  private
    FApplicableNote: IXMLApplicableNoteTypeList;
  protected
    { IXMLUtilizedLogisticsTransportEquipmentType }
    function Get_ID: UnicodeString;
    function Get_ApplicableNote: IXMLApplicableNoteTypeList;
    function Get_CategoryCode: UnicodeString;
    function Get_CharacteristicCode: Integer;
    function Get_AffixedLogisticsSeal: IXMLAffixedLogisticsSealType;
    procedure Set_ID(Value: UnicodeString);
    procedure Set_CategoryCode(Value: UnicodeString);
    procedure Set_CharacteristicCode(Value: Integer);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLUtilizedLogisticsTransportEquipmentTypeList }

  TXMLUtilizedLogisticsTransportEquipmentTypeList = class(TXMLNodeCollection, IXMLUtilizedLogisticsTransportEquipmentTypeList)
  protected
    { IXMLUtilizedLogisticsTransportEquipmentTypeList }
    function Add: IXMLUtilizedLogisticsTransportEquipmentType;
    function Insert(const Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;

    function Get_Item(Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;
  end;

{ TXMLAffixedLogisticsSealType }

  TXMLAffixedLogisticsSealType = class(TXMLNode, IXMLAffixedLogisticsSealType)
  protected
    { IXMLAffixedLogisticsSealType }
    function Get_ID: UnicodeString;
    procedure Set_ID(Value: UnicodeString);
  end;

{ TXMLMainCarriageLogisticsTransportMovementType }

  TXMLMainCarriageLogisticsTransportMovementType = class(TXMLNodeCollection, IXMLMainCarriageLogisticsTransportMovementType)
  protected
    { IXMLMainCarriageLogisticsTransportMovementType }
    function Get_SpecifiedTransportEvent(Index: Integer): IXMLSpecifiedTransportEventType;
    function Add: IXMLSpecifiedTransportEventType;
    function Insert(const Index: Integer): IXMLSpecifiedTransportEventType;
  public
    procedure AfterConstruction; override;
  end;

{ TXMLSpecifiedTransportEventType }

  TXMLSpecifiedTransportEventType = class(TXMLNode, IXMLSpecifiedTransportEventType)
  protected
    { IXMLSpecifiedTransportEventType }
    function Get_ID: Integer;
    function Get_TypeCode: Integer;
    function Get_Description: UnicodeString;
    function Get_CertifyingTradeParty: IXMLCertifyingTradePartyType;
    procedure Set_ID(Value: Integer);
    procedure Set_TypeCode(Value: Integer);
    procedure Set_Description(Value: UnicodeString);
  public
    procedure AfterConstruction; override;
  end;

{ TXMLDeliveryInstructionsType }

  TXMLDeliveryInstructionsType = class(TXMLNode, IXMLDeliveryInstructionsType)
  protected
    { IXMLDeliveryInstructionsType }
    function Get_Description: UnicodeString;
    function Get_DescriptionCode: UnicodeString;
    procedure Set_Description(Value: UnicodeString);
    procedure Set_DescriptionCode(Value: UnicodeString);
  end;

{ Global Functions }

function GetUAECMR(Doc: IXMLDocument): IXMLUAECMRType;
function LoadUAECMR(const FileName: string): IXMLUAECMRType;
function NewUAECMR: IXMLUAECMRType;

const
  TargetNamespace = '';

implementation

{ Global Functions }

function GetUAECMR(Doc: IXMLDocument): IXMLUAECMRType;
begin
  Result := Doc.GetDocBinding('UAECMR', TXMLUAECMRType, TargetNamespace) as IXMLUAECMRType;
end;

function LoadUAECMR(const FileName: string): IXMLUAECMRType;
begin
  Result := LoadXMLDocument(FileName).GetDocBinding('UAECMR', TXMLUAECMRType, TargetNamespace) as IXMLUAECMRType;
end;

function NewUAECMR: IXMLUAECMRType;
begin
  Result := NewXMLDocument.GetDocBinding('UAECMR', TXMLUAECMRType, TargetNamespace) as IXMLUAECMRType;
  Result.SetAttributeNS('xmlns:qdt', '', 'urn:un:unece:uncefact:data:standard:QualifiedDataType:103');
  Result.SetAttributeNS('xmlns:ram', '', 'urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:103');
  Result.SetAttributeNS('xmlns:uas', '', 'urn:ua:signatures:SignaturesExtensions:1');
  Result.SetAttributeNS('xmlns:udt', '', 'urn:un:unece:uncefact:data:standard:UnqualifiedDataType:27');
end;

{ TXMLUAECMRType }

procedure TXMLUAECMRType.AfterConstruction;
begin
  RegisterChildNode('eCMR', TXMLECMRType);
  inherited;
end;

function TXMLUAECMRType.Get_ECMR: IXMLECMRType;
begin
  Result := ChildNodes['eCMR'] as IXMLECMRType;
end;

{ TXMLECMRType }

procedure TXMLECMRType.AfterConstruction;
begin
  RegisterChildNode('ExchangedDocumentContext', TXMLExchangedDocumentContextType);
  RegisterChildNode('ExchangedDocument', TXMLExchangedDocumentType);
  RegisterChildNode('SpecifiedSupplyChainConsignment', TXMLSpecifiedSupplyChainConsignmentType);
  inherited;
end;

function TXMLECMRType.Get_ExchangedDocumentContext: IXMLExchangedDocumentContextType;
begin
  Result := ChildNodes['ExchangedDocumentContext'] as IXMLExchangedDocumentContextType;
end;

function TXMLECMRType.Get_ExchangedDocument: IXMLExchangedDocumentType;
begin
  Result := ChildNodes['ExchangedDocument'] as IXMLExchangedDocumentType;
end;

function TXMLECMRType.Get_SpecifiedSupplyChainConsignment: IXMLSpecifiedSupplyChainConsignmentType;
begin
  Result := ChildNodes['SpecifiedSupplyChainConsignment'] as IXMLSpecifiedSupplyChainConsignmentType;
end;

{ TXMLExchangedDocumentContextType }

procedure TXMLExchangedDocumentContextType.AfterConstruction;
begin
  RegisterChildNode('BusinessProcessSpecifiedDocumentContextParameter', TXMLBusinessProcessSpecifiedDocumentContextParameterType);
  RegisterChildNode('GuidelineSpecifiedDocumentContextParameter', TXMLGuidelineSpecifiedDocumentContextParameterType);
  inherited;
end;

function TXMLExchangedDocumentContextType.Get_SpecifiedTransactionID: UnicodeString;
begin
  Result := ChildNodes['ram:SpecifiedTransactionID'].Text;
end;

procedure TXMLExchangedDocumentContextType.Set_SpecifiedTransactionID(Value: UnicodeString);
begin
  ChildNodes['ram:SpecifiedTransactionID'].NodeValue := Value;
end;

function TXMLExchangedDocumentContextType.Get_BusinessProcessSpecifiedDocumentContextParameter: IXMLBusinessProcessSpecifiedDocumentContextParameterType;
begin
  Result := ChildNodes['ram:BusinessProcessSpecifiedDocumentContextParameter'] as IXMLBusinessProcessSpecifiedDocumentContextParameterType;
end;

function TXMLExchangedDocumentContextType.Get_GuidelineSpecifiedDocumentContextParameter: IXMLGuidelineSpecifiedDocumentContextParameterType;
begin
  Result := ChildNodes['ram:GuidelineSpecifiedDocumentContextParameter'] as IXMLGuidelineSpecifiedDocumentContextParameterType;
end;

{ TXMLBusinessProcessSpecifiedDocumentContextParameterType }

function TXMLBusinessProcessSpecifiedDocumentContextParameterType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLBusinessProcessSpecifiedDocumentContextParameterType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

{ TXMLGuidelineSpecifiedDocumentContextParameterType }

function TXMLGuidelineSpecifiedDocumentContextParameterType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLGuidelineSpecifiedDocumentContextParameterType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

{ TXMLExchangedDocumentType }

procedure TXMLExchangedDocumentType.AfterConstruction;
begin
  RegisterChildNode('ram:IssueDateTime', TXMLIssueDateTimeType);
  RegisterChildNode('ram:IncludedNote', TXMLIncludedNoteType);
  RegisterChildNode('ram:IssueLogisticsLocation', TXMLIssueLogisticsLocationType);
  FIncludedNote := CreateCollection(TXMLIncludedNoteTypeList, IXMLIncludedNoteType, 'ram:IncludedNote') as IXMLIncludedNoteTypeList;
  inherited;
end;

function TXMLExchangedDocumentType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLExchangedDocumentType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

function TXMLExchangedDocumentType.Get_IssueDateTime: IXMLIssueDateTimeType;
begin
  Result := ChildNodes['ram:IssueDateTime'] as IXMLIssueDateTimeType;
end;

function TXMLExchangedDocumentType.Get_IncludedNote: IXMLIncludedNoteTypeList;
begin
  Result := FIncludedNote;
end;

function TXMLExchangedDocumentType.Get_IssueLogisticsLocation: IXMLIssueLogisticsLocationType;
begin
  Result := ChildNodes['ram:IssueLogisticsLocation'] as IXMLIssueLogisticsLocationType;
end;

{ TXMLIssueDateTimeType }

function TXMLIssueDateTimeType.Get_DateTime: UnicodeString;
begin
  Result := ChildNodes['udt:DateTime'].Text;
end;

procedure TXMLIssueDateTimeType.Set_DateTime(Value: UnicodeString);
begin
  ChildNodes['udt:DateTime'].NodeValue := Value;
end;

{ TXMLIncludedNoteType }

procedure TXMLIncludedNoteType.AfterConstruction;
begin
  RegisterChildNode('ContentCode', TXMLContentCodeType);
  inherited;
end;

function TXMLIncludedNoteType.Get_ContentCode: IXMLContentCodeType;
begin
  Result := ChildNodes['ram:ContentCode'] as IXMLContentCodeType;
end;

function TXMLIncludedNoteType.Get_Content: UnicodeString;
begin
  Result := ChildNodes['ram:Content'].Text;
end;

procedure TXMLIncludedNoteType.Set_Content(Value: UnicodeString);
begin
  ChildNodes['ram:Content'].NodeValue := Value;
end;

{ TXMLIncludedNoteTypeList }

function TXMLIncludedNoteTypeList.Add: IXMLIncludedNoteType;
begin
  Result := AddItem(-1) as IXMLIncludedNoteType;
end;

function TXMLIncludedNoteTypeList.Insert(const Index: Integer): IXMLIncludedNoteType;
begin
  Result := AddItem(Index) as IXMLIncludedNoteType;
end;

function TXMLIncludedNoteTypeList.Get_Item(Index: Integer): IXMLIncludedNoteType;
begin
  Result := List[Index] as IXMLIncludedNoteType;
end;

{ TXMLContentCodeType }

function TXMLContentCodeType.Get_ListAgencyID: UnicodeString;
begin
  Result := AttributeNodes['listAgencyID'].Text;
end;

procedure TXMLContentCodeType.Set_ListAgencyID(Value: UnicodeString);
begin
  SetAttribute('listAgencyID', Value);
end;

{ TXMLIssueLogisticsLocationType }

function TXMLIssueLogisticsLocationType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLIssueLogisticsLocationType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLIssueLogisticsLocationType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLIssueLogisticsLocationType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

{ TXMLSpecifiedSupplyChainConsignmentType }

procedure TXMLSpecifiedSupplyChainConsignmentType.AfterConstruction;
begin
  RegisterChildNode('GrossWeightMeasure', TXMLGrossWeightMeasureType);
  RegisterChildNode('AssociatedInvoiceAmount', TXMLAssociatedInvoiceAmountType);
  RegisterChildNode('ConsignorTradeParty', TXMLConsignorTradePartyType);
  RegisterChildNode('ConsigneeTradeParty', TXMLConsigneeTradePartyType);
  RegisterChildNode('CarrierTradeParty', TXMLCarrierTradePartyType);
  RegisterChildNode('NotifiedTradeParty', TXMLNotifiedTradePartyType);
  RegisterChildNode('CarrierAcceptanceLogisticsLocation', TXMLCarrierAcceptanceLogisticsLocationType);
  RegisterChildNode('ConsigneeReceiptLogisticsLocation', TXMLConsigneeReceiptLogisticsLocationType);
  RegisterChildNode('DeliveryTransportEvent', TXMLDeliveryTransportEventType);
  RegisterChildNode('PickUpTransportEvent', TXMLPickUpTransportEventType);
  RegisterChildNode('ram:IncludedSupplyChainConsignmentItem', TXMLIncludedSupplyChainConsignmentItemType);
  RegisterChildNode('ram:UtilizedLogisticsTransportEquipment', TXMLUtilizedLogisticsTransportEquipmentType);
  RegisterChildNode('MainCarriageLogisticsTransportMovement', TXMLMainCarriageLogisticsTransportMovementType);
  RegisterChildNode('DeliveryInstructions', TXMLDeliveryInstructionsType);
  FIncludedSupplyChainConsignmentItem := CreateCollection(TXMLIncludedSupplyChainConsignmentItemTypeList, IXMLIncludedSupplyChainConsignmentItemType, 'ram:IncludedSupplyChainConsignmentItem') as IXMLIncludedSupplyChainConsignmentItemTypeList;
  FUtilizedLogisticsTransportEquipment := CreateCollection(TXMLUtilizedLogisticsTransportEquipmentTypeList, IXMLUtilizedLogisticsTransportEquipmentType, 'ram:UtilizedLogisticsTransportEquipment') as IXMLUtilizedLogisticsTransportEquipmentTypeList;
  inherited;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
begin
  Result := ChildNodes['ram:GrossWeightMeasure'] as IXMLGrossWeightMeasureType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_AssociatedInvoiceAmount: IXMLAssociatedInvoiceAmountType;
begin
  Result := ChildNodes['ram:AssociatedInvoiceAmount'] as IXMLAssociatedInvoiceAmountType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_ConsignmentItemQuantity: Double;
begin
  Result := ChildNodes['ram:ConsignmentItemQuantity'].NodeValue;
end;

procedure TXMLSpecifiedSupplyChainConsignmentType.Set_ConsignmentItemQuantity(Value: Double);
begin
  ChildNodes['ram:ConsignmentItemQuantity'].NodeValue := Value;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_ConsignorTradeParty: IXMLConsignorTradePartyType;
begin
  Result := ChildNodes['ram:ConsignorTradeParty'] as IXMLConsignorTradePartyType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_ConsigneeTradeParty: IXMLConsigneeTradePartyType;
begin
  Result := ChildNodes['ram:ConsigneeTradeParty'] as IXMLConsigneeTradePartyType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_CarrierTradeParty: IXMLCarrierTradePartyType;
begin
  Result := ChildNodes['ram:CarrierTradeParty'] as IXMLCarrierTradePartyType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_NotifiedTradeParty: IXMLNotifiedTradePartyType;
begin
  Result := ChildNodes['ram:NotifiedTradeParty'] as IXMLNotifiedTradePartyType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_CarrierAcceptanceLogisticsLocation: IXMLCarrierAcceptanceLogisticsLocationType;
begin
  Result := ChildNodes['ram:CarrierAcceptanceLogisticsLocation'] as IXMLCarrierAcceptanceLogisticsLocationType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_ConsigneeReceiptLogisticsLocation: IXMLConsigneeReceiptLogisticsLocationType;
begin
  Result := ChildNodes['ram:ConsigneeReceiptLogisticsLocation'] as IXMLConsigneeReceiptLogisticsLocationType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_DeliveryTransportEvent: IXMLDeliveryTransportEventType;
begin
  Result := ChildNodes['ram:DeliveryTransportEvent'] as IXMLDeliveryTransportEventType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_PickUpTransportEvent: IXMLPickUpTransportEventType;
begin
  Result := ChildNodes['ram:PickUpTransportEvent'] as IXMLPickUpTransportEventType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_IncludedSupplyChainConsignmentItem: IXMLIncludedSupplyChainConsignmentItemTypeList;
begin
  Result := FIncludedSupplyChainConsignmentItem;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_UtilizedLogisticsTransportEquipment: IXMLUtilizedLogisticsTransportEquipmentTypeList;
begin
  Result := FUtilizedLogisticsTransportEquipment;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_MainCarriageLogisticsTransportMovement: IXMLMainCarriageLogisticsTransportMovementType;
begin
  Result := ChildNodes['ram:MainCarriageLogisticsTransportMovement'] as IXMLMainCarriageLogisticsTransportMovementType;
end;

function TXMLSpecifiedSupplyChainConsignmentType.Get_DeliveryInstructions: IXMLDeliveryInstructionsType;
begin
  Result := ChildNodes['ram:DeliveryInstructions'] as IXMLDeliveryInstructionsType;
end;

{ TXMLGrossWeightMeasureType }

function TXMLGrossWeightMeasureType.Get_UnitCode: UnicodeString;
begin
  Result := AttributeNodes['unitCode'].Text;
end;

procedure TXMLGrossWeightMeasureType.Set_UnitCode(Value: UnicodeString);
begin
  SetAttribute('unitCode', Value);
end;

{ TXMLAssociatedInvoiceAmountType }

function TXMLAssociatedInvoiceAmountType.Get_CurrencyID: UnicodeString;
begin
  Result := AttributeNodes['currencyID'].Text;
end;

procedure TXMLAssociatedInvoiceAmountType.Set_CurrencyID(Value: UnicodeString);
begin
  SetAttribute('currencyID', Value);
end;

{ TXMLConsignorTradePartyType }

procedure TXMLConsignorTradePartyType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('DefinedTradeContact', TXMLDefinedTradeContactType);
  RegisterChildNode('SpecifiedGovernmentRegistration', TXMLSpecifiedGovernmentRegistrationType);
  RegisterChildNode('SpecifiedTaxRegistration', TXMLSpecifiedTaxRegistrationType);
  inherited;
end;

function TXMLConsignorTradePartyType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLConsignorTradePartyType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLConsignorTradePartyType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLConsignorTradePartyType.Get_RoleCode: UnicodeString;
begin
  Result := ChildNodes['ram:RoleCode'].Text;
end;

procedure TXMLConsignorTradePartyType.Set_RoleCode(Value: UnicodeString);
begin
  ChildNodes['ram:RoleCode'].NodeValue := Value;
end;

function TXMLConsignorTradePartyType.Get_PostalTradeAddress: IXMLPostalTradeAddressType;
begin
  Result := ChildNodes['ram:PostalTradeAddress'] as IXMLPostalTradeAddressType;
end;

function TXMLConsignorTradePartyType.Get_DefinedTradeContact: IXMLDefinedTradeContactType;
begin
  Result := ChildNodes['ram:DefinedTradeContact'] as IXMLDefinedTradeContactType;
end;

function TXMLConsignorTradePartyType.Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedGovernmentRegistration'] as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLConsignorTradePartyType.Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedTaxRegistration'] as IXMLSpecifiedTaxRegistrationType;
end;

{ TXMLIDType }

function TXMLIDType.Get_SchemeAgencyID: UnicodeString;
begin
  Result := AttributeNodes['schemeAgencyID'].Text;
end;

procedure TXMLIDType.Set_SchemeAgencyID(Value: UnicodeString);
begin
  SetAttribute('schemeAgencyID', Value);
end;

{ TXMLPostalTradeAddressType }

function TXMLPostalTradeAddressType.Get_PostcodeCode: UnicodeString;
begin
  Result := ChildNodes['ram:PostcodeCode'].Text;
end;

procedure TXMLPostalTradeAddressType.Set_PostcodeCode(Value: UnicodeString);
begin
  ChildNodes['ram:PostcodeCode'].NodeValue := Value;
end;

function TXMLPostalTradeAddressType.Get_StreetName: UnicodeString;
begin
  Result := ChildNodes['ram:StreetName'].Text;
end;

procedure TXMLPostalTradeAddressType.Set_StreetName(Value: UnicodeString);
begin
  ChildNodes['ram:StreetName'].NodeValue := Value;
end;

function TXMLPostalTradeAddressType.Get_CityName: UnicodeString;
begin
  Result := ChildNodes['ram:CityName'].Text;
end;

procedure TXMLPostalTradeAddressType.Set_CityName(Value: UnicodeString);
begin
  ChildNodes['ram:CityName'].NodeValue := Value;
end;

function TXMLPostalTradeAddressType.Get_CountryID: UnicodeString;
begin
  Result := ChildNodes['ram:CountryID'].Text;
end;

procedure TXMLPostalTradeAddressType.Set_CountryID(Value: UnicodeString);
begin
  ChildNodes['ram:CountryID'].NodeValue := Value;
end;

function TXMLPostalTradeAddressType.Get_CountrySubDivisionName: UnicodeString;
begin
  Result := ChildNodes['ram:CountrySubDivisionName'].Text;
end;

procedure TXMLPostalTradeAddressType.Set_CountrySubDivisionName(Value: UnicodeString);
begin
  ChildNodes['ram:CountrySubDivisionName'].NodeValue := Value;
end;

{ TXMLConsigneeTradePartyType }

procedure TXMLConsigneeTradePartyType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('DefinedTradeContact', TXMLDefinedTradeContactType);
  RegisterChildNode('SpecifiedGovernmentRegistration', TXMLSpecifiedGovernmentRegistrationType);
  RegisterChildNode('SpecifiedTaxRegistration', TXMLSpecifiedTaxRegistrationType);
  inherited;
end;

function TXMLConsigneeTradePartyType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLConsigneeTradePartyType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLConsigneeTradePartyType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLConsigneeTradePartyType.Get_RoleCode: UnicodeString;
begin
  Result := ChildNodes['ram:RoleCode'].Text;
end;

procedure TXMLConsigneeTradePartyType.Set_RoleCode(Value: UnicodeString);
begin
  ChildNodes['ram:RoleCode'].NodeValue := Value;
end;

function TXMLConsigneeTradePartyType.Get_PostalTradeAddress: IXMLPostalTradeAddressType;
begin
  Result := ChildNodes['ram:PostalTradeAddress'] as IXMLPostalTradeAddressType;
end;

function TXMLConsigneeTradePartyType.Get_DefinedTradeContact: IXMLDefinedTradeContactType;
begin
  Result := ChildNodes['ram:DefinedTradeContact'] as IXMLDefinedTradeContactType;
end;

function TXMLConsigneeTradePartyType.Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedGovernmentRegistration'] as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLConsigneeTradePartyType.Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedTaxRegistration'] as IXMLSpecifiedTaxRegistrationType;
end;

{ TXMLSpecifiedTaxRegistrationType }

procedure TXMLSpecifiedTaxRegistrationType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  inherited;
end;

function TXMLSpecifiedTaxRegistrationType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

{ TXMLSpecifiedGovernmentRegistrationType }

function TXMLSpecifiedGovernmentRegistrationType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLSpecifiedGovernmentRegistrationType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

function TXMLSpecifiedGovernmentRegistrationType.Get_TypeCode: UnicodeString;
begin
  Result := ChildNodes['ram:TypeCode'].Text;
end;

procedure TXMLSpecifiedGovernmentRegistrationType.Set_TypeCode(Value: UnicodeString);
begin
  ChildNodes['ram:TypeCode'].NodeValue := Value;
end;

{ TXMLSpecifiedGovernmentRegistrationTypeList }

function TXMLSpecifiedGovernmentRegistrationTypeList.Add: IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := AddItem(-1) as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLSpecifiedGovernmentRegistrationTypeList.Insert(const Index: Integer): IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := AddItem(Index) as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLSpecifiedGovernmentRegistrationTypeList.Get_Item(Index: Integer): IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := List[Index] as IXMLSpecifiedGovernmentRegistrationType;
end;


{ TXMLCarrierTradePartyType }

procedure TXMLCarrierTradePartyType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('DefinedTradeContact', TXMLDefinedTradeContactType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('SpecifiedTaxRegistration', TXMLSpecifiedTaxRegistrationType);
  RegisterChildNode('SpecifiedGovernmentRegistration', TXMLSpecifiedGovernmentRegistrationType);
  FSpecifiedGovernmentRegistration := CreateCollection(TXMLSpecifiedGovernmentRegistrationTypeList, IXMLSpecifiedGovernmentRegistrationType, 'ram:SpecifiedGovernmentRegistration') as IXMLSpecifiedGovernmentRegistrationTypeList;
  inherited;
end;

function TXMLCarrierTradePartyType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLCarrierTradePartyType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLCarrierTradePartyType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLCarrierTradePartyType.Get_RoleCode: UnicodeString;
begin
  Result := ChildNodes['ram:RoleCode'].Text;
end;

procedure TXMLCarrierTradePartyType.Set_RoleCode(Value: UnicodeString);
begin
  ChildNodes['ram:RoleCode'].NodeValue := Value;
end;

function TXMLCarrierTradePartyType.Get_DefinedTradeContact: IXMLDefinedTradeContactType;
begin
  Result := ChildNodes['ram:DefinedTradeContact'] as IXMLDefinedTradeContactType;
end;

function TXMLCarrierTradePartyType.Get_PostalTradeAddress: IXMLPostalTradeAddressType;
begin
  Result := ChildNodes['ram:PostalTradeAddress'] as IXMLPostalTradeAddressType;
end;

function TXMLCarrierTradePartyType.Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedTaxRegistration'] as IXMLSpecifiedTaxRegistrationType;
end;

function TXMLCarrierTradePartyType.Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationTypeList;
begin
  Result :=FSpecifiedGovernmentRegistration;
end;

{ TXMLDefinedTradeContactType }

procedure TXMLDefinedTradeContactType.AfterConstruction;
begin
  RegisterChildNode('TelephoneUniversalCommunication', TXMLTelephoneUniversalCommunicationType);
  RegisterChildNode('EmailURIUniversalCommunication', TXMLEmailURIUniversalCommunicationType);
  RegisterChildNode('MobileTelephoneUniversalCommunication', TXMLMobileTelephoneUniversalCommunicationType);
  inherited;
end;

function TXMLDefinedTradeContactType.Get_PersonName: UnicodeString;
begin
  Result := ChildNodes['ram:PersonName'].Text;
end;

procedure TXMLDefinedTradeContactType.Set_PersonName(Value: UnicodeString);
begin
  ChildNodes['ram:PersonName'].NodeValue := Value;
end;

function TXMLDefinedTradeContactType.Get_TelephoneUniversalCommunication: IXMLTelephoneUniversalCommunicationType;
begin
  Result := ChildNodes['ram:TelephoneUniversalCommunication'] as IXMLTelephoneUniversalCommunicationType;
end;

function TXMLDefinedTradeContactType.Get_EmailURIUniversalCommunication: IXMLEmailURIUniversalCommunicationType;
begin
  Result := ChildNodes['ram:EmailURIUniversalCommunication'] as IXMLEmailURIUniversalCommunicationType;
end;

function TXMLDefinedTradeContactType.Get_MobileTelephoneUniversalCommunication: IXMLMobileTelephoneUniversalCommunicationType;
begin
  Result := ChildNodes['ram:MobileTelephoneUniversalCommunication'] as IXMLMobileTelephoneUniversalCommunicationType;
end;

{ TXMLTelephoneUniversalCommunicationType }

function TXMLTelephoneUniversalCommunicationType.Get_CompleteNumber: UnicodeString;
begin
  Result := ChildNodes['ram:CompleteNumber'].Text;
end;

procedure TXMLTelephoneUniversalCommunicationType.Set_CompleteNumber(Value: UnicodeString);
begin
  ChildNodes['ram:CompleteNumber'].NodeValue := Value;
end;

{ TXMLEmailURIUniversalCommunicationType }

function TXMLEmailURIUniversalCommunicationType.Get_CompleteNumber: UnicodeString;
begin
  Result := ChildNodes['ram:CompleteNumber'].Text;
end;

procedure TXMLEmailURIUniversalCommunicationType.Set_CompleteNumber(Value: UnicodeString);
begin
  ChildNodes['ram:CompleteNumber'].NodeValue := Value;
end;

{ TXMLMobileTelephoneUniversalCommunicationType }

function TXMLMobileTelephoneUniversalCommunicationType.Get_CompleteNumber: UnicodeString;
begin
  Result := ChildNodes['ram:CompleteNumber'].Text;
end;

procedure TXMLMobileTelephoneUniversalCommunicationType.Set_CompleteNumber(Value: UnicodeString);
begin
  ChildNodes['ram:CompleteNumber'].NodeValue := Value;
end;

{ TXMLNotifiedTradePartyType }

procedure TXMLNotifiedTradePartyType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('SpecifiedTaxRegistration', TXMLSpecifiedTaxRegistrationType);
  RegisterChildNode('SpecifiedGovernmentRegistration', TXMLSpecifiedGovernmentRegistrationType);
  inherited;
end;

function TXMLNotifiedTradePartyType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLNotifiedTradePartyType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLNotifiedTradePartyType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLNotifiedTradePartyType.Get_RoleCode: UnicodeString;
begin
  Result := ChildNodes['ram:RoleCode'].Text;
end;

procedure TXMLNotifiedTradePartyType.Set_RoleCode(Value: UnicodeString);
begin
  ChildNodes['ram:RoleCode'].NodeValue := Value;
end;

function TXMLNotifiedTradePartyType.Get_PostalTradeAddress: IXMLPostalTradeAddressType;
begin
  Result := ChildNodes['ram:PostalTradeAddress'] as IXMLPostalTradeAddressType;
end;

function TXMLNotifiedTradePartyType.Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedGovernmentRegistration'] as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLNotifiedTradePartyType.Get_DefinedTradeContact: IXMLDefinedTradeContactType;
begin
  Result := ChildNodes['ram:DefinedTradeContact'] as IXMLDefinedTradeContactType;
end;

function TXMLNotifiedTradePartyType.Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedTaxRegistration'] as IXMLSpecifiedTaxRegistrationType;
end;

{ TXMLCarrierAcceptanceLogisticsLocationType }

procedure TXMLCarrierAcceptanceLogisticsLocationType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('ram:PhysicalGeographicalCoordinate', TXMLPhysicalGeographicalCoordinateType);
  inherited;
end;

function TXMLCarrierAcceptanceLogisticsLocationType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLCarrierAcceptanceLogisticsLocationType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLCarrierAcceptanceLogisticsLocationType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLCarrierAcceptanceLogisticsLocationType.Get_TypeCode: Integer;
begin
  Result := ChildNodes['ram:TypeCode'].NodeValue;
end;

procedure TXMLCarrierAcceptanceLogisticsLocationType.Set_TypeCode(Value: Integer);
begin
  ChildNodes['ram:TypeCode'].NodeValue := Value;
end;

function TXMLCarrierAcceptanceLogisticsLocationType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLCarrierAcceptanceLogisticsLocationType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLCarrierAcceptanceLogisticsLocationType.Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
begin
  Result := ChildNodes['ram:PhysicalGeographicalCoordinate'] as IXMLPhysicalGeographicalCoordinateType;
end;

{ TXMLConsigneeReceiptLogisticsLocationType }

procedure TXMLConsigneeReceiptLogisticsLocationType.AfterConstruction;
begin
  RegisterChildNode('ID', TXMLIDType);
  RegisterChildNode('ram:PhysicalGeographicalCoordinate', TXMLPhysicalGeographicalCoordinateType);
  inherited;
end;

function TXMLConsigneeReceiptLogisticsLocationType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLConsigneeReceiptLogisticsLocationType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLConsigneeReceiptLogisticsLocationType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLConsigneeReceiptLogisticsLocationType.Get_TypeCode: Integer;
begin
  Result := ChildNodes['ram:TypeCode'].NodeValue;
end;

procedure TXMLConsigneeReceiptLogisticsLocationType.Set_TypeCode(Value: Integer);
begin
  ChildNodes['ram:TypeCode'].NodeValue := Value;
end;

function TXMLConsigneeReceiptLogisticsLocationType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLConsigneeReceiptLogisticsLocationType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLConsigneeReceiptLogisticsLocationType.Get_PhysicalGeographicalCoordinate: IXMLPhysicalGeographicalCoordinateType;
begin
  Result := ChildNodes['ram:PhysicalGeographicalCoordinate'] as IXMLPhysicalGeographicalCoordinateType;
end;

{ TXMLPhysicalGeographicalCoordinateType }

procedure TXMLPhysicalGeographicalCoordinateType.AfterConstruction;
begin
  RegisterChildNode('SystemID', TXMLSystemIDType);
  inherited;
end;

function TXMLPhysicalGeographicalCoordinateType.Get_LatitudeMeasure: UnicodeString;
begin
  Result := ChildNodes['ram:LatitudeMeasure'].Text;
end;

procedure TXMLPhysicalGeographicalCoordinateType.Set_LatitudeMeasure(Value: UnicodeString);
begin
  ChildNodes['ram:LatitudeMeasure'].NodeValue := Value;
end;

function TXMLPhysicalGeographicalCoordinateType.Get_LongitudeMeasure: UnicodeString;
begin
  Result := ChildNodes['ram:LongitudeMeasure'].Text;
end;

procedure TXMLPhysicalGeographicalCoordinateType.Set_LongitudeMeasure(Value: UnicodeString);
begin
  ChildNodes['ram:LongitudeMeasure'].NodeValue := Value;
end;

function TXMLPhysicalGeographicalCoordinateType.Get_SystemID: IXMLSystemIDType;
begin
  Result := ChildNodes['ram:SystemID'] as IXMLSystemIDType;
end;

{ TXMLSystemIDType }

function TXMLSystemIDType.Get_SchemeAgencyID: UnicodeString;
begin
  Result := AttributeNodes['schemeAgencyID'].Text;
end;

procedure TXMLSystemIDType.Set_SchemeAgencyID(Value: UnicodeString);
begin
  SetAttribute('schemeAgencyID', Value);
end;

{ TXMLDeliveryTransportEventType }

procedure TXMLDeliveryTransportEventType.AfterConstruction;
begin
  RegisterChildNode('ActualOccurrenceDateTime', TXMLActualOccurrenceDateTimeType);
  RegisterChildNode('ScheduledOccurrenceDateTime', TXMLScheduledOccurrenceDateTimeType);
  RegisterChildNode('ram:CertifyingTradeParty', TXMLCertifyingTradePartyType);
  FCertifyingTradeParty := CreateCollection(TXMLCertifyingTradePartyTypeList, IXMLCertifyingTradePartyType, 'ram:CertifyingTradeParty') as IXMLCertifyingTradePartyTypeList;
  inherited;
end;

function TXMLDeliveryTransportEventType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLDeliveryTransportEventType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLDeliveryTransportEventType.Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
begin
  Result := ChildNodes['ram:ActualOccurrenceDateTime'] as IXMLActualOccurrenceDateTimeType;
end;

function TXMLDeliveryTransportEventType.Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
begin
  Result := ChildNodes['ram:ScheduledOccurrenceDateTime'] as IXMLScheduledOccurrenceDateTimeType;
end;

function TXMLDeliveryTransportEventType.Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
begin
  Result := FCertifyingTradeParty;
end;

{ TXMLActualOccurrenceDateTimeType }

function TXMLActualOccurrenceDateTimeType.Get_DateTime: UnicodeString;
begin
  Result := ChildNodes['udt:DateTime'].Text;
end;

procedure TXMLActualOccurrenceDateTimeType.Set_DateTime(Value: UnicodeString);
begin
  ChildNodes['udt:DateTime'].NodeValue := Value;
end;

{ TXMLScheduledOccurrenceDateTimeType }

function TXMLScheduledOccurrenceDateTimeType.Get_DateTime: UnicodeString;
begin
  Result := ChildNodes['udt:DateTime'].Text;
end;

procedure TXMLScheduledOccurrenceDateTimeType.Set_DateTime(Value: UnicodeString);
begin
  ChildNodes['udt:DateTime'].NodeValue := Value;
end;

{ TXMLCertifyingTradePartyType }

procedure TXMLCertifyingTradePartyType.AfterConstruction;
begin
  RegisterChildNode('DefinedTradeContact', TXMLDefinedTradeContactType);
  RegisterChildNode('PostalTradeAddress', TXMLPostalTradeAddressType);
  RegisterChildNode('SpecifiedGovernmentRegistration', TXMLSpecifiedGovernmentRegistrationType);
  RegisterChildNode('SpecifiedTaxRegistration', TXMLSpecifiedTaxRegistrationType);
  RegisterChildNode('ID', TXMLIDType);
  inherited;
end;

function TXMLCertifyingTradePartyType.Get_Name: UnicodeString;
begin
  Result := ChildNodes['ram:Name'].Text;
end;

procedure TXMLCertifyingTradePartyType.Set_Name(Value: UnicodeString);
begin
  ChildNodes['ram:Name'].NodeValue := Value;
end;

function TXMLCertifyingTradePartyType.Get_RoleCode: UnicodeString;
begin
  Result := ChildNodes['ram:RoleCode'].Text;
end;

procedure TXMLCertifyingTradePartyType.Set_RoleCode(Value: UnicodeString);
begin
  ChildNodes['ram:RoleCode'].NodeValue := Value;
end;

function TXMLCertifyingTradePartyType.Get_DefinedTradeContact: IXMLDefinedTradeContactType;
begin
  Result := ChildNodes['ram:DefinedTradeContact'] as IXMLDefinedTradeContactType;
end;

function TXMLCertifyingTradePartyType.Get_PostalTradeAddress: IXMLPostalTradeAddressType;
begin
  Result := ChildNodes['ram:PostalTradeAddress'] as IXMLPostalTradeAddressType;
end;

function TXMLCertifyingTradePartyType.Get_SpecifiedGovernmentRegistration: IXMLSpecifiedGovernmentRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedGovernmentRegistration'] as IXMLSpecifiedGovernmentRegistrationType;
end;

function TXMLCertifyingTradePartyType.Get_ID: IXMLIDType;
begin
  Result := ChildNodes['ram:ID'] as IXMLIDType;
end;

function TXMLCertifyingTradePartyType.Get_SpecifiedTaxRegistration: IXMLSpecifiedTaxRegistrationType;
begin
  Result := ChildNodes['ram:SpecifiedTaxRegistration'] as IXMLSpecifiedTaxRegistrationType;
end;

{ TXMLCertifyingTradePartyTypeList }

function TXMLCertifyingTradePartyTypeList.Add: IXMLCertifyingTradePartyType;
begin
  Result := AddItem(-1) as IXMLCertifyingTradePartyType;
end;

function TXMLCertifyingTradePartyTypeList.Insert(const Index: Integer): IXMLCertifyingTradePartyType;
begin
  Result := AddItem(Index) as IXMLCertifyingTradePartyType;
end;

function TXMLCertifyingTradePartyTypeList.Get_Item(Index: Integer): IXMLCertifyingTradePartyType;
begin
  Result := List[Index] as IXMLCertifyingTradePartyType;
end;

{ TXMLPickUpTransportEventType }

procedure TXMLPickUpTransportEventType.AfterConstruction;
begin
  RegisterChildNode('ActualOccurrenceDateTime', TXMLActualOccurrenceDateTimeType);
  RegisterChildNode('ScheduledOccurrenceDateTime', TXMLScheduledOccurrenceDateTimeType);
  RegisterChildNode('ram:CertifyingTradeParty', TXMLCertifyingTradePartyType);
  FCertifyingTradeParty := CreateCollection(TXMLCertifyingTradePartyTypeList, IXMLCertifyingTradePartyType, 'ram:CertifyingTradeParty') as IXMLCertifyingTradePartyTypeList;
  inherited;
end;

function TXMLPickUpTransportEventType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLPickUpTransportEventType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLPickUpTransportEventType.Get_ActualOccurrenceDateTime: IXMLActualOccurrenceDateTimeType;
begin
  Result := ChildNodes['ram:ActualOccurrenceDateTime'] as IXMLActualOccurrenceDateTimeType;
end;

function TXMLPickUpTransportEventType.Get_ScheduledOccurrenceDateTime: IXMLScheduledOccurrenceDateTimeType;
begin
  Result := ChildNodes['ram:ScheduledOccurrenceDateTime'] as IXMLScheduledOccurrenceDateTimeType;
end;

function TXMLPickUpTransportEventType.Get_CertifyingTradeParty: IXMLCertifyingTradePartyTypeList;
begin
  Result := FCertifyingTradeParty;
end;

{ TXMLIncludedSupplyChainConsignmentItemType }

procedure TXMLIncludedSupplyChainConsignmentItemType.AfterConstruction;
begin
  RegisterChildNode('InvoiceAmount', TXMLInvoiceAmountType);
  RegisterChildNode('GrossWeightMeasure', TXMLGrossWeightMeasureType);
  RegisterChildNode('TariffQuantity', TXMLTariffQuantityType);
  RegisterChildNode('GlobalID', TXMLGlobalIDType);
  RegisterChildNode('NatureIdentificationTransportCargo', TXMLNatureIdentificationTransportCargoType);
  RegisterChildNode('ApplicableTransportDangerousGoods', TXMLApplicableTransportDangerousGoodsType);
  RegisterChildNode('AssociatedReferencedLogisticsTransportEquipment', TXMLAssociatedReferencedLogisticsTransportEquipmentType);
  RegisterChildNode('TransportLogisticsPackage', TXMLTransportLogisticsPackageType);
  RegisterChildNode('ApplicableNote', TXMLApplicableNoteType);
  FApplicableNote := CreateCollection(TXMLApplicableNoteTypeList, IXMLApplicableNoteType, 'ram:ApplicableNote') as IXMLApplicableNoteTypeList;
  inherited;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_SequenceNumeric: Integer;
begin
  Result := ChildNodes['ram:SequenceNumeric'].NodeValue;
end;

procedure TXMLIncludedSupplyChainConsignmentItemType.Set_SequenceNumeric(Value: Integer);
begin
  ChildNodes['ram:SequenceNumeric'].NodeValue := Value;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_InvoiceAmount: IXMLInvoiceAmountType;
begin
  Result := ChildNodes['ram:InvoiceAmount'] as IXMLInvoiceAmountType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_GrossWeightMeasure: IXMLGrossWeightMeasureType;
begin
  Result := ChildNodes['ram:GrossWeightMeasure'] as IXMLGrossWeightMeasureType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_TariffQuantity: IXMLTariffQuantityType;
begin
  Result := ChildNodes['ram:TariffQuantity'] as IXMLTariffQuantityType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_GlobalID: IXMLGlobalIDType;
begin
  Result := ChildNodes['ram:GlobalID'] as IXMLGlobalIDType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_NatureIdentificationTransportCargo: IXMLNatureIdentificationTransportCargoType;
begin
  Result := ChildNodes['ram:NatureIdentificationTransportCargo'] as IXMLNatureIdentificationTransportCargoType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_ApplicableTransportDangerousGoods: IXMLApplicableTransportDangerousGoodsType;
begin
  Result := ChildNodes['ram:ApplicableTransportDangerousGoods'] as IXMLApplicableTransportDangerousGoodsType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_AssociatedReferencedLogisticsTransportEquipment: IXMLAssociatedReferencedLogisticsTransportEquipmentType;
begin
  Result := ChildNodes['ram:AssociatedReferencedLogisticsTransportEquipment'] as IXMLAssociatedReferencedLogisticsTransportEquipmentType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_TransportLogisticsPackage: IXMLTransportLogisticsPackageType;
begin
  Result := ChildNodes['ram:TransportLogisticsPackage'] as IXMLTransportLogisticsPackageType;
end;

function TXMLIncludedSupplyChainConsignmentItemType.Get_ApplicableNote: IXMLApplicableNoteTypeList;
begin
  Result := FApplicableNote;
end;

{ TXMLIncludedSupplyChainConsignmentItemTypeList }

function TXMLIncludedSupplyChainConsignmentItemTypeList.Add: IXMLIncludedSupplyChainConsignmentItemType;
begin
  Result := AddItem(-1) as IXMLIncludedSupplyChainConsignmentItemType;
end;

function TXMLIncludedSupplyChainConsignmentItemTypeList.Insert(const Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;
begin
  Result := AddItem(Index) as IXMLIncludedSupplyChainConsignmentItemType;
end;

function TXMLIncludedSupplyChainConsignmentItemTypeList.Get_Item(Index: Integer): IXMLIncludedSupplyChainConsignmentItemType;
begin
  Result := List[Index] as IXMLIncludedSupplyChainConsignmentItemType;
end;

{ TXMLInvoiceAmountType }

function TXMLInvoiceAmountType.Get_CurrencyID: UnicodeString;
begin
  Result := AttributeNodes['currencyID'].Text;
end;

procedure TXMLInvoiceAmountType.Set_CurrencyID(Value: UnicodeString);
begin
  SetAttribute('currencyID', Value);
end;

{ TXMLTariffQuantityType }

function TXMLTariffQuantityType.Get_UnitCode: UnicodeString;
begin
  Result := AttributeNodes['unitCode'].Text;
end;

procedure TXMLTariffQuantityType.Set_UnitCode(Value: UnicodeString);
begin
  SetAttribute('unitCode', Value);
end;

{ TXMLGlobalIDType }

function TXMLGlobalIDType.Get_SchemeAgencyID: UnicodeString;
begin
  Result := AttributeNodes['schemeAgencyID'].Text;
end;

procedure TXMLGlobalIDType.Set_SchemeAgencyID(Value: UnicodeString);
begin
  SetAttribute('schemeAgencyID', Value);
end;

{ TXMLNatureIdentificationTransportCargoType }

function TXMLNatureIdentificationTransportCargoType.Get_Identification: UnicodeString;
begin
  Result := ChildNodes['ram:Identification'].Text;
end;

procedure TXMLNatureIdentificationTransportCargoType.Set_Identification(Value: UnicodeString);
begin
  ChildNodes['ram:Identification'].NodeValue := Value;
end;

{ TXMLApplicableTransportDangerousGoodsType }

function TXMLApplicableTransportDangerousGoodsType.Get_UNDGIdentificationCode: Integer;
begin
  Result := ChildNodes['ram:UNDGIdentificationCode'].NodeValue;
end;

procedure TXMLApplicableTransportDangerousGoodsType.Set_UNDGIdentificationCode(Value: Integer);
begin
  ChildNodes['ram:UNDGIdentificationCode'].NodeValue := Value;
end;

function TXMLApplicableTransportDangerousGoodsType.Get_PackagingDangerLevelCode: Integer;
begin
  Result := ChildNodes['ram:PackagingDangerLevelCode'].NodeValue;
end;

procedure TXMLApplicableTransportDangerousGoodsType.Set_PackagingDangerLevelCode(Value: Integer);
begin
  ChildNodes['ram:PackagingDangerLevelCode'].NodeValue := Value;
end;

{ TXMLAssociatedReferencedLogisticsTransportEquipmentType }

function TXMLAssociatedReferencedLogisticsTransportEquipmentType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLAssociatedReferencedLogisticsTransportEquipmentType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

{ TXMLTransportLogisticsPackageType }

procedure TXMLTransportLogisticsPackageType.AfterConstruction;
begin
  RegisterChildNode('PhysicalLogisticsShippingMarks', TXMLPhysicalLogisticsShippingMarksType);
  inherited;
end;

function TXMLTransportLogisticsPackageType.Get_ItemQuantity: Double;
begin
  Result := ChildNodes['ram:ItemQuantity'].NodeValue;
end;

procedure TXMLTransportLogisticsPackageType.Set_ItemQuantity(Value: Double);
begin
  ChildNodes['ram:ItemQuantity'].NodeValue := Value;
end;

function TXMLTransportLogisticsPackageType.Get_TypeCode: UnicodeString;
begin
  Result := ChildNodes['ram:TypeCode'].Text;
end;

procedure TXMLTransportLogisticsPackageType.Set_TypeCode(Value: UnicodeString);
begin
  ChildNodes['ram:TypeCode'].NodeValue := Value;
end;

function TXMLTransportLogisticsPackageType.Get_Type_: UnicodeString;
begin
  Result := ChildNodes['ram:Type'].Text;
end;

procedure TXMLTransportLogisticsPackageType.Set_Type_(Value: UnicodeString);
begin
  ChildNodes['ram:Type'].NodeValue := Value;
end;

function TXMLTransportLogisticsPackageType.Get_PhysicalLogisticsShippingMarks: IXMLPhysicalLogisticsShippingMarksType;
begin
  Result := ChildNodes['ram:PhysicalLogisticsShippingMarks'] as IXMLPhysicalLogisticsShippingMarksType;
end;

{ TXMLPhysicalLogisticsShippingMarksType }

procedure TXMLPhysicalLogisticsShippingMarksType.AfterConstruction;
begin
  RegisterChildNode('BarcodeLogisticsLabel', TXMLBarcodeLogisticsLabelType);
  inherited;
end;

function TXMLPhysicalLogisticsShippingMarksType.Get_Marking: UnicodeString;
begin
  Result := ChildNodes['ram:Marking'].Text;
end;

procedure TXMLPhysicalLogisticsShippingMarksType.Set_Marking(Value: UnicodeString);
begin
  ChildNodes['ram:Marking'].NodeValue := Value;
end;

function TXMLPhysicalLogisticsShippingMarksType.Get_BarcodeLogisticsLabel: IXMLBarcodeLogisticsLabelType;
begin
  Result := ChildNodes['ram:BarcodeLogisticsLabel'] as IXMLBarcodeLogisticsLabelType;
end;

{ TXMLBarcodeLogisticsLabelType }

function TXMLBarcodeLogisticsLabelType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLBarcodeLogisticsLabelType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

{ TXMLApplicableNoteType }

function TXMLApplicableNoteType.Get_ContentCode: UnicodeString;
begin
  Result := ChildNodes['ram:ContentCode'].Text;
end;

procedure TXMLApplicableNoteType.Set_ContentCode(Value: UnicodeString);
begin
  ChildNodes['ram:ContentCode'].NodeValue := Value;
end;

function TXMLApplicableNoteType.Get_Content: UnicodeString;
begin
  Result := ChildNodes['ram:Content'].Text;
end;

procedure TXMLApplicableNoteType.Set_Content(Value: UnicodeString);
begin
  ChildNodes['ram:Content'].NodeValue := Value;
end;

{ TXMLApplicableNoteTypeList }

function TXMLApplicableNoteTypeList.Add: IXMLApplicableNoteType;
begin
  Result := AddItem(-1) as IXMLApplicableNoteType;
end;

function TXMLApplicableNoteTypeList.Insert(const Index: Integer): IXMLApplicableNoteType;
begin
  Result := AddItem(Index) as IXMLApplicableNoteType;
end;

function TXMLApplicableNoteTypeList.Get_Item(Index: Integer): IXMLApplicableNoteType;
begin
  Result := List[Index] as IXMLApplicableNoteType;
end;

{ TXMLUtilizedLogisticsTransportEquipmentType }

procedure TXMLUtilizedLogisticsTransportEquipmentType.AfterConstruction;
begin
  RegisterChildNode('ApplicableNote', TXMLApplicableNoteType);
  RegisterChildNode('AffixedLogisticsSeal', TXMLAffixedLogisticsSealType);
  FApplicableNote := CreateCollection(TXMLApplicableNoteTypeList, IXMLApplicableNoteType, 'ram:ApplicableNote') as IXMLApplicableNoteTypeList;
  inherited;
end;

function TXMLUtilizedLogisticsTransportEquipmentType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLUtilizedLogisticsTransportEquipmentType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

function TXMLUtilizedLogisticsTransportEquipmentType.Get_ApplicableNote: IXMLApplicableNoteTypeList;
begin
  Result := FApplicableNote;
end;

function TXMLUtilizedLogisticsTransportEquipmentType.Get_CategoryCode: UnicodeString;
begin
  Result := ChildNodes['ram:CategoryCode'].Text;
end;

procedure TXMLUtilizedLogisticsTransportEquipmentType.Set_CategoryCode(Value: UnicodeString);
begin
  ChildNodes['ram:CategoryCode'].NodeValue := Value;
end;

function TXMLUtilizedLogisticsTransportEquipmentType.Get_CharacteristicCode: Integer;
begin
  Result := ChildNodes['ram:CharacteristicCode'].NodeValue;
end;

procedure TXMLUtilizedLogisticsTransportEquipmentType.Set_CharacteristicCode(Value: Integer);
begin
  ChildNodes['ram:CharacteristicCode'].NodeValue := Value;
end;

function TXMLUtilizedLogisticsTransportEquipmentType.Get_AffixedLogisticsSeal: IXMLAffixedLogisticsSealType;
begin
  Result := ChildNodes['ram:AffixedLogisticsSeal'] as IXMLAffixedLogisticsSealType;
end;

{ TXMLUtilizedLogisticsTransportEquipmentTypeList }

function TXMLUtilizedLogisticsTransportEquipmentTypeList.Add: IXMLUtilizedLogisticsTransportEquipmentType;
begin
  Result := AddItem(-1) as IXMLUtilizedLogisticsTransportEquipmentType;
end;

function TXMLUtilizedLogisticsTransportEquipmentTypeList.Insert(const Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;
begin
  Result := AddItem(Index) as IXMLUtilizedLogisticsTransportEquipmentType;
end;

function TXMLUtilizedLogisticsTransportEquipmentTypeList.Get_Item(Index: Integer): IXMLUtilizedLogisticsTransportEquipmentType;
begin
  Result := List[Index] as IXMLUtilizedLogisticsTransportEquipmentType;
end;

{ TXMLAffixedLogisticsSealType }

function TXMLAffixedLogisticsSealType.Get_ID: UnicodeString;
begin
  Result := ChildNodes['ram:ID'].Text;
end;

procedure TXMLAffixedLogisticsSealType.Set_ID(Value: UnicodeString);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

{ TXMLMainCarriageLogisticsTransportMovementType }

procedure TXMLMainCarriageLogisticsTransportMovementType.AfterConstruction;
begin
  RegisterChildNode('SpecifiedTransportEvent', TXMLSpecifiedTransportEventType);
  ItemTag := 'SpecifiedTransportEvent';
  ItemInterface := IXMLSpecifiedTransportEventType;
  inherited;
end;

function TXMLMainCarriageLogisticsTransportMovementType.Get_SpecifiedTransportEvent(Index: Integer): IXMLSpecifiedTransportEventType;
begin
  Result := List[Index] as IXMLSpecifiedTransportEventType;
end;

function TXMLMainCarriageLogisticsTransportMovementType.Add: IXMLSpecifiedTransportEventType;
begin
  Result := AddItem(-1) as IXMLSpecifiedTransportEventType;
end;

function TXMLMainCarriageLogisticsTransportMovementType.Insert(const Index: Integer): IXMLSpecifiedTransportEventType;
begin
  Result := AddItem(Index) as IXMLSpecifiedTransportEventType;
end;

{ TXMLSpecifiedTransportEventType }

procedure TXMLSpecifiedTransportEventType.AfterConstruction;
begin
  RegisterChildNode('CertifyingTradeParty', TXMLCertifyingTradePartyType);
  inherited;
end;

function TXMLSpecifiedTransportEventType.Get_ID: Integer;
begin
  Result := ChildNodes['ram:ID'].NodeValue;
end;

procedure TXMLSpecifiedTransportEventType.Set_ID(Value: Integer);
begin
  ChildNodes['ram:ID'].NodeValue := Value;
end;

function TXMLSpecifiedTransportEventType.Get_TypeCode: Integer;
begin
  Result := ChildNodes['ram:TypeCode'].NodeValue;
end;

procedure TXMLSpecifiedTransportEventType.Set_TypeCode(Value: Integer);
begin
  ChildNodes['ram:TypeCode'].NodeValue := Value;
end;

function TXMLSpecifiedTransportEventType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLSpecifiedTransportEventType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLSpecifiedTransportEventType.Get_CertifyingTradeParty: IXMLCertifyingTradePartyType;
begin
  Result := ChildNodes['ram:CertifyingTradeParty'] as IXMLCertifyingTradePartyType;
end;

{ TXMLDeliveryInstructionsType }

function TXMLDeliveryInstructionsType.Get_Description: UnicodeString;
begin
  Result := ChildNodes['ram:Description'].Text;
end;

procedure TXMLDeliveryInstructionsType.Set_Description(Value: UnicodeString);
begin
  ChildNodes['ram:Description'].NodeValue := Value;
end;

function TXMLDeliveryInstructionsType.Get_DescriptionCode: UnicodeString;
begin
  Result := ChildNodes['ram:DescriptionCode'].Text;
end;

procedure TXMLDeliveryInstructionsType.Set_DescriptionCode(Value: UnicodeString);
begin
  ChildNodes['ram:DescriptionCode'].NodeValue := Value;
end;

end.