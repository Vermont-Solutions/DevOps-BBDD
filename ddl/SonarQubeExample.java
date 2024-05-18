package com.example;

public class SonarQubeExample {

    public int add(int a, int b) {
        return a + b;
    }

    public int subtract(int a, int b) {
        return a - b;
    }

    public static void main(String[] args) {
        SonarQubeExample example = new SonarQubeExample();
        System.out.println("Addition: " + example.add(5, 3));
        System.out.println("Subtraction: " + example.subtract(5, 3));
    }
}
