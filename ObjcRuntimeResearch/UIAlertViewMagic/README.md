# UIAlertViewMagic
通过给UIAlertView增加一个actionBlock回调，来演示OC runtime的**“关联对象”(objc_associatedObject)**的功能。  

**注意：**

* iOS9.0后，你应该使用**UIAlertController**，弃用UIAlerView！
* 此Demo主要演示如何使用runtime的**objc_associatedObject**，模拟部分UIAlertController的功能，使用了category来增加一个方法，**但在实际开发中，还是建议通过继承使用子类来实现。**毕竟category中增加实例变量属于一种trick技巧。
* 我们需要一个内部block来存储外部传进来的action，但是category无法在一般意义上增加实例变量， 因此可以使用runtime魔法实现。 
* 我们依旧遵照**“勿在分类中声明属性”**这一原则，不声明void (^block)(UIAlertView*, NSInteger)的@property，直接提供一个setup方法。
