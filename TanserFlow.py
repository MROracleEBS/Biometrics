import tensorflow as tf

print(tf.VERSION)
###########################################
a = tf.add(3, 5)
sess = tf.Session()
print (sess.run(a))
sess.close()
###########################################
xx = 2
yy = 3
op1 = tf.add(xx, yy)
op2 = tf.mul(xx, yy)
op3 = tf.pow(op2, op1)
with tf.Session() as sess:
    op3 = sess.run(op3)
sess.close()
###########################################
x = 2
y = 3
add_op =  tf.add(x, y)
mul_op =  tf.multiply(x, y)
useless =  tf.multiply(x, add_op)
pow_op =  tf.pow(add_op, mul_op)
with tf.Session() as sess:
    z = sess.run(pow_op)
print(z)
sess.close()
###########################################
