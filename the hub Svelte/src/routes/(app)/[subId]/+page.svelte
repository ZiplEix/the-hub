<script>
    import Header from '$lib/Header.svelte';

    export let data;
    $: sub = data.sub;
    $: comments = data.comments;
</script>

<Header />
<div class="main">
    <div class="sub">
        <h1>{sub.title}</h1>
        <h4>{sub.body}</h4>
    </div>
    <div class="comments">
        {#each comments as comment (comment.id)}
        <div class="comment">
            <div class="pseudo">
                <p>{comment.email}</p>
            </div>
            <div class="content">
                <div class="note">
                    <p>{comment.id}</p>
                </div>
                <div class="text">
                    <p>{comment.name}</p>
                    <p>{comment.body}</p>
                </div>
            </div>
        </div>
        {/each}
    </div>
</div>

<style>
    .main {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin: 1em;
    }
    .sub {
        margin: 1em;
        padding: 10px;
        padding-left: 1em;

        width: 97%;
        background-color: rgb(228, 228, 228);
        border-radius: 15px;

        filter: drop-shadow(3px 5px 6px rgba(0, 0, 0, 0.25));
    }
    .comments {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        margin-left: 3em;
    }
    .comment {
        display: flex;
        flex-direction: column;

        margin: 10px 0;
        padding-left: 1em;

        width: 97%;
        background-color: rgb(228, 228, 228);
        border-radius: 15px;

        filter: drop-shadow(3px 5px 6px rgba(0, 0, 0, 0.25));
    }
    .content {
        display: flex;
        flex-direction: row;
        align-items: center;
    }
    .note {
        background: red;
        min-width: 50px;
        max-width: 50px;
        height: 50px;
        border-radius: 50%;
        font-size: 1.2em;
        margin-right: 1em;

        display: flex;
        justify-content: center;
        align-items: center;
    }
</style>
