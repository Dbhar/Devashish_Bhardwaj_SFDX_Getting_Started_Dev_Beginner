public class Stack {
    private List<Object> elements;
    private Integer stackPointer;
    public Stack(){
        elements = new List<Object>();
        stackPointer = -1;
    }
    
    public void push(Object obj){
        elements.add(obj);
        stackPointer++;
    }
    
    public Object peek(){
        return elements.get(stackPointer);
    }
    
    public Object pop(){
        Object element = elements.remove(stackPointer);
        stackPointer--;
        return element;
    }

}