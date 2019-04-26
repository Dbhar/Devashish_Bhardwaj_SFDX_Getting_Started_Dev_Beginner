<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Greet_Birthday</fullName>
        <description>Greet Birthday</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Happy_Birthday</template>
    </alerts>
    <alerts>
        <fullName>Send_Mail</fullName>
        <description>Send Mail</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Teacher_Experience_Is_more_Than_5_years</template>
    </alerts>
    <fieldUpdates>
        <fullName>Test_Action</fullName>
        <field>Experience__c</field>
        <formula>Experience__c + 2</formula>
        <name>Test Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Greet Birthday</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Birthdate</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Greet_Birthday</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.Next_Birthday__c</offsetFromField>
            <timeLength>-2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Send_Mail_If_Experience_Is_More_Than_5_years</fullName>
        <actions>
            <name>Send_Mail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Experience__c</field>
            <operation>greaterThan</operation>
            <value>5</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
