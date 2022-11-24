<script>
    export let data
    $: posts = data.posts
</script>

<div>
    {#each posts as post}
        <h1>{post.title}</h1>
        <p>{post.body}</p>
    {/each}
</div>