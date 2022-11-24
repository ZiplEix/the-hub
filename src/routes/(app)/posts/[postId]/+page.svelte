<script>
    export let data
    $: post = data.post
</script>

<div>
    <h1>{post.title}</h1>
    <p>{post.body}</p>
</div>