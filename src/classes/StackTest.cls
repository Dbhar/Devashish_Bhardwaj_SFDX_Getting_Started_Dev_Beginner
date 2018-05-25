@isTest
private class StackTest {
    private testMethod static void testPush(){
        Stack integerStack = new Stack();
        integerStack.push(1);
        integerStack.push(2);
        integerStack.push(3);
        System.assertEquals(new List<Integer>{1, 2, 3}, integerStack.getElements());
    }
    
    private testMethod static void testPop(){
        Stack integerStack = new Stack();
        integerStack.push(1);
        integerStack.push(2);
        integerStack.push(3);
        Integer el = (Integer)integerStack.pop();
        System.assertEquals(3, el);
        System.assertEquals(new List<Integer>{1, 2}, integerStack.getElements());
        el = (Integer)integerStack.pop();
        System.assertEquals(2, el);
        System.assertEquals(new List<Integer>{1}, integerStack.getElements());
    }
    
    private testMethod static void testPeek(){
        Stack integerStack = new Stack();
        integerStack.push(1);
        integerStack.push(2);
        integerStack.push(3);
        Integer el = (Integer)integerStack.peek();
        System.assertEquals(3, el);
        System.assertEquals(new List<Integer>{1, 2, 3}, integerStack.getElements());
        el = (Integer)integerStack.peek();
        System.assertEquals(3, el);
        System.assertEquals(new List<Integer>{1, 2, 3}, integerStack.getElements());
    }
}