<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Account_Update_Detected</fullName>
        <description>Account Update Detected</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Updated</template>
    </alerts>
    <rules>
        <fullName>Account_Updated_By_Non_Owner</fullName>
        <actions>
            <name>Account_Update_Detected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND( AnnualRevenue &gt; 1000000,OwnerId &lt;&gt; LastModifiedById)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
